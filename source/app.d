import vibe.d;
import anisette;
import std.process : environment;
import std.conv : to;
import std.file : mkdirRecurse;

void main()
{
    string cacheDir = environment.get("HOME", "/home/Alcoholic") ~ "/.config/anisette-v3/lib";
    mkdirRecurse(cacheDir);

    ushort port = 6969;
    if (auto p = environment.get("PORT"))
    {
        port = p.to!ushort;
    }

    auto server = new HTTPServer;
    server.registerHandler!AnisetteV1Handler("/");
    server.registerHandler!AnisetteV3Handler("/v3");
    server.listenHTTP("0.0.0.0", port);
    runEventLoop();
}

final class AnisetteV1Handler : HTTPServerRequestHandler
{
    void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
    {
        res.writeJsonBody(generateAnisetteDataV1());
    }
}

final class AnisetteV3Handler : HTTPServerRequestHandler
{
    void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
    {
        res.writeJsonBody(generateAnisetteDataV3());
    }
}
