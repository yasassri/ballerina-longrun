package services;

import ballerina.net.http;
import ballerina.lang.system;

@http:configuration {
    basePath:"/slowservice"
}
service <http> ResponseDelayedService {
    string connection = system:getEnv("CONNECTION");

     @http:resourceConfig {
        methods:["POST", "GET", "HEAD", "PUT", "DELETE"],
        path:"/delay/{delay}"
    }
    resource slowBackEndOneResource (message m, @http:PathParam {value:"delay"}string delay) {
        string headerValue;
        message response;
	string path = "/slow?delay=" + delay;

        string method = http:getMethod(m);
        http:ClientConnector httpCheck = create http:ClientConnector(connection);
        response = httpCheck.execute(method, path, m);

        reply response;
    }

}
