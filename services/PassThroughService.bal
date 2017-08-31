package services;

import ballerina.net.http;
import ballerina.lang.system;

@http:configuration {
    basePath:"/passthrough"
}
service <http> PassThroughService {
    string connection = system:getEnv("CONNECTION");

     @http:resourceConfig {
        methods:["POST", "GET", "HEAD", "PUT", "DELETE"],
        path:"/call/payloadsmall"
    }
    resource passThroughSmallPayloadResource (message m) {
        string headerValue;
        message response;
        string path = "/echo";

        string method = http:getMethod(m);
        http:ClientConnector httpCheck = create http:ClientConnector(connection);
        response = httpCheck.execute(method, path, m);

        reply response;
    }

     @http:resourceConfig {
        methods:["POST", "GET", "HEAD", "PUT", "DELETE"],
        path:"/call/payloadmedium"
    }
    resource passThroughMediumPayloadResource (message m) {
        string headerValue;
        message response;
        string path = "/echo";

        string method = http:getMethod(m);
        http:ClientConnector httpCheck = create http:ClientConnector(connection);
        response = httpCheck.execute(method, path, m);

        reply response;
    }

       @http:resourceConfig {
        methods:["POST", "GET", "HEAD", "PUT", "DELETE"],
        path:"/call/payloadlarge"
    }
    resource passThroughLargePayloadResource (message m) {
        string headerValue;
        message response;
        string path = "/echo";

        string method = http:getMethod(m);
        http:ClientConnector httpCheck = create http:ClientConnector(connection);
        response = httpCheck.execute(method, path, m);

        reply response;
    }

    @http:resourceConfig {
        methods:["POST", "GET", "HEAD", "PUT", "DELETE"],
        path:"/call/payloadxlarge"
    }
    resource passThroughXLargePayloadResource (message m) {
        string headerValue;
        message response;
        string path = "/echo";

        string method = http:getMethod(m);
        http:ClientConnector httpCheck = create http:ClientConnector(connection);
        response = httpCheck.execute(method, path, m);

        reply response;
    }

}
