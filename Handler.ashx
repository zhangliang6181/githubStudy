<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;

public class Handler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string act = context.Request.Params["act"].ToLower();
        switch (act.ToLower())
        {
            case "acttest":
                actTest(context);
                break;
            //default:
            //    context.Response.Write(ExtFunctions.WriteJsonResult(false, "", "action参数错误。"));
            //    break;
        }
        context.Response.End();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public void actTest(HttpContext context)
    {
        context.Response.Write("{\"success\":true,\"message\":\"测试请求\"}");
    }
}