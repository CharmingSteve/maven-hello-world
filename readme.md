# A simple, minimal Maven example: hello world

I have made changes and automations to this repo.

NON ROOT

The build is automatic when you push to the master branch. 
It runs https://github.com/CharmingSteve/maven-hello-world/blob/master/.github/workflows/maven-build.yml . 
The pipeline takes the current verion , especially  the patch and adds 1 to the patch. 
the version started at 1.0.0 and has moved up with each push. 
The pom.xml uses a var ${revision} that it uses inside the app. The Git Tag is the source of truth for the version number.
The first stage of the Dockerfile creates an artifact with the version and patch as part of the file number.
All stages of the Dockerfile do stuff as nonroot user.
the nonroot user is assigned a UID so that the deployment will be happy
The App.java file has been updated to add my name as well as the version with new patch number
The pipeline builds the java artifact and copies it to a second stage in the Dockerfile. The new file does not have the version in it, so that it can run with a standard Docker  CMD in the container's foreground.
The second stage Docker image is pushed with the new artifact to Docker Hub with a tag with the version and patch, as well as latest.
The values.yaml for the helm chart is updated to reflect the newest Docker tag
The Git tag is exchanged for the newest patch number

This app in the Docker container can run as a single Docker Container, Running it gets the Hello World output with my name and the version number. It will always run as nonroot user inside the container.

deploy from helm.
Helm files have also been added to the repo. The Helm creates pod as a Job. The output of the job goes to the pods log. Run ` helm upgrade --install maven-hello-world .` 
The helm also runs as nonroot user with UID


---



To create the files in this git repo we've already run `mvn archetype:generate` from http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html
    
    mvn archetype:generate -DgroupId=com.myapp.app -DartifactId=myapp -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false

Now, to print "Hello World!", type either...

    cd myapp
    mvn compile
    java -cp target/classes com.myapp.app.App

or...

    cd myapp
    mvn package
    java -cp target/myapp-1.0-SNAPSHOT.jar com.myapp.app.App

Running `mvn clean` will get us back to only the source Java and the `pom.xml`:

    murphy:myapp pdurbin$ mvn clean --quiet
    murphy:myapp pdurbin$ ack -a -f
    pom.xml
    src/main/java/com/myapp/app/App.java
    src/test/java/com/myapp/app/AppTest.java

Running `mvn compile` produces a class file:

    murphy:myapp pdurbin$ mvn compile --quiet
    murphy:myapp pdurbin$ ack -a -f
    pom.xml
    src/main/java/com/myapp/app/App.java
    src/test/java/com/myapp/app/AppTest.java
    target/classes/com/myapp/app/App.class
    murphy:myapp pdurbin$ 
    murphy:myapp pdurbin$ java -cp target/classes com.myapp.app.App
    Hello World!

Running `mvn package` does a compile and creates the target directory, including a jar:

    murphy:myapp pdurbin$ mvn clean --quiet
    murphy:myapp pdurbin$ mvn package > /dev/null
    murphy:myapp pdurbin$ ack -a -f
    pom.xml
    src/main/java/com/myapp/app/App.java
    src/test/java/com/myapp/app/AppTest.java
    target/classes/com/myapp/app/App.class
    target/maven-archiver/pom.properties
    target/myapp-1.0-SNAPSHOT.jar
    target/surefire-reports/com.myapp.app.AppTest.txt
    target/surefire-reports/TEST-com.myapp.app.AppTest.xml
    target/test-classes/com/myapp/app/AppTest.class
    murphy:myapp pdurbin$ 
    murphy:myapp pdurbin$ java -cp target/myapp-1.0-SNAPSHOT.jar com.myapp.app.App
    Hello World!

Running `mvn clean compile exec:java` requires http://mojo.codehaus.org/exec-maven-plugin/

Running `java -jar target/myapp-1.0-SNAPSHOT.jar` requires http://maven.apache.org/plugins/maven-shade-plugin/

# Runnable Jar:
JAR Plugin
The Maven’s jar plugin will create jar file and we need to define the main class that will get executed when we run the jar file.
```
<plugin>
  <artifactId>maven-jar-plugin</artifactId>
  <version>3.0.2</version>
  <configuration>
    <archive>
      <manifest>
        <addClasspath>true</addClasspath>
        <mainClass>com.myapp.App</mainClass>
      </manifest>
    </archive>
  </configuration>
</plugin>
```


# Folder tree before package:
```
├── pom.xml
└── src
    ├── main
    │   └── java
    │       └── com
    │           └── myapp
    │               └── app
    │                   └── App.java
    └── test
        └── java
            └── com
                └── myapp
                    └── app
                        └── AppTest.java

```
# Folder tree after package:
```

.
├── pom.xml
├── src
│   ├── main
│   │   └── java
│   │       └── com
│   │           └── myapp
│   │               └── app
│   │                   └── App.java
│   └── test
│       └── java
│           └── com
│               └── myapp
│                   └── app
│                       └── AppTest.java
└── target
    ├── classes
    │   └── com
    │       └── myapp
    │           └── app
    │               └── App.class
    ├── generated-sources
    │   └── annotations
    ├── generated-test-sources
    │   └── test-annotations
    ├── maven-archiver
    │   └── pom.properties
    ├── maven-status
    │   └── maven-compiler-plugin
    │       ├── compile
    │       │   └── default-compile
    │       │       ├── createdFiles.lst
    │       │       └── inputFiles.lst
    │       └── testCompile
    │           └── default-testCompile
    │               ├── createdFiles.lst
    │               └── inputFiles.lst
    ├── myapp-1.0-SNAPSHOT.jar
    ├── surefire-reports
    │   ├── com.myapp.app.AppTest.txt
    │   └── TEST-com.myapp.app.AppTest.xml
    └── test-classes
        └── com
            └── myapp
                └── app
                    └── AppTest.class
```
 
