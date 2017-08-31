package services;

import ballerina.net.http;
import ballerina.lang.system;

@http:configuration {
    basePath:"/terminate"
}
service <http> ConnectionTerminateService {
    string connection = system:getEnv("CONNECTION");

     @http:resourceConfig {
        methods:["POST", "GET", "HEAD", "PUT", "DELETE"],
        path:"/call"
    }
    resource connectionTerminateResource (message m) {
        string headerValue;
        message response;
	string path = "/conclose?delay=2";

        string method = http:getMethod(m);
        http:ClientConnector httpCheck = create http:ClientConnector(connection);
        response = httpCheck.execute(method, path, m);

        reply response;
    }

}
