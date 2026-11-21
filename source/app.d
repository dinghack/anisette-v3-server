import vibe.d;
import std.process : environment;
import std.conv : to;
import std.file : mkdirRecurse;

void main()
{
    // 自动创建缓存目录，解决 Render 500 (-45054)
    string cacheDir = environment.get("HOME", "/home/Alcoholic") ~ "/.config/anisette-v3/lib";
    mkdirRecurse(cacheDir);

    ushort port = 6969;
    if (auto p = environment.get("PORT")) {
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
        import anisette : generateAnisetteDataV1;
        res.writeJsonBody(generateAnisetteDataV1());
    }
}

final class AnisetteV3Handler : HTTPServerRequestHandler
{
    void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
    {
        import anisette : generateAnisetteDataV3;
        res.writeJsonBody(generateAnisetteDataV3());
    }
}
