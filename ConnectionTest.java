package org.zod;

import java.io.*;
import java.net.*;
import javax.net.ssl.*;
import java.security.*;
import java.security.cert.*;

class ConnectionTest {
    public static void main(String[] args) throws java.lang.Throwable {

        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] {
            new X509TrustManager() {
                public X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
                public void checkClientTrusted(
                    X509Certificate[] certs, String authType) {
                    }
                public void checkServerTrusted(
                    X509Certificate[] certs, String authType) {
                }
            }
        };

        // Install the all-trusting trust manager
        SSLContext sc = SSLContext.getInstance("SSL");
        sc.init(null, trustAllCerts, new java.security.SecureRandom());
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

        // Create an all-trusting host verifier
        HostnameVerifier allHostsValid = new HostnameVerifier() {
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        };

        // Install the all-trusting host verifier
        HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

        // Now you can access an https URL without having the certificate in the truststore
        URL url = new URL(args[0]);
        HttpURLConnection con = (HttpURLConnection)url.openConnection();
        int responseCode = con.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) { // success
                BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
                String inputLine;
                StringBuffer response = new StringBuffer();

                while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine + System.getProperty("line.separator"));
                }
                in.close();

                // print result
                System.out.println(response.toString());
        } else {
                System.out.println("GET request did not work.");
        }
    }
}
