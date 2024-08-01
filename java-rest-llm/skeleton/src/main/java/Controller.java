import io.micrometer.common.util.StringUtils;

@RestController
public class Controller 
{
    private static final Log log = LogFactory.getLog(Controller.class);

    @GetMapping("/")
    public String sayHello(@RequestParam(value = "name", defaultValue = null)  String name)
    {
        if (StringUtils.isEmpty(name))
        {
            log.info("Saying hello to no one!");
            return "Hello!  Don't by shy.  Tell me your name next time!";
        }

        log.info("Saying hello to " + name);
        return "Hello " + name + "!  Thank you for trying out my basic service today.";
    }
}
