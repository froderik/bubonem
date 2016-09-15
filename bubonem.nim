import asynchttpserver, asyncdispatch
import emerald

proc markup() {.html_templ.} =
  html(lang="en"):
    head:
      title: "bubonem"
    body:
      p: "Hello yo"

proc render_response() : string =
  var markupThing = newMarkup()
  var ss = newStringStream()
  markupThing.render(ss)
  var rendered = ss.readAll()
  ss.flush()
  ss.close()
  return rendered
  

var server = newAsyncHttpServer()

proc cb(req: Request) {.async.} =
  await req.respond(Http200, render_response())

waitFor server.serve(Port(4321), cb)