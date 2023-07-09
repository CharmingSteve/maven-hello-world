package com.myapp;

import java.io.IOException;
import java.util.jar.Manifest;

public class App {
    public static void main(String[] args) {
        String version = null;
        try {
            // Get the manifest file from the current JAR
            Manifest manifest = new Manifest(App.class.getResourceAsStream("/META-INF/MANIFEST.MF"));
            // Get the Implementation-Version attribute
            version = manifest.getMainAttributes().getValue("Implementation-Version");
        } catch (IOException e) {
            // Handle exception
        }
        System.out.println("Hello World! This is Yishayahu, This is build version " + version);
    }
}
