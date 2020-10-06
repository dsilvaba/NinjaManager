using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(NinjaManagerASP.Startup))]
namespace NinjaManagerASP
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
