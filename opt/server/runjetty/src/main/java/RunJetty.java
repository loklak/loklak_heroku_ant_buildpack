import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.nio.SelectChannelConnector;
import org.eclipse.jetty.webapp.WebAppContext;

public class RunJetty
{
    public static void main(String[] args) throws Exception
    {
        Server server = new Server();

        Connector connector = new SelectChannelConnector();
        connector.setPort(Integer.getInteger("jetty.port",8080).intValue());
        server.setConnectors(new Connector[]
        { connector });

        String war = args.length > 0?args[0]: "../test-jetty-webapp/target/test-jetty-webapp-" + Server.getVersion();
        String path = args.length > 1?args[1]:"/";

        System.err.println(war + " " + path);

        WebAppContext webapp = new WebAppContext();
        webapp.setContextPath(path);
        webapp.setWar(war);

        server.setHandler(webapp);

        server.start();
        server.join();
    }
}
