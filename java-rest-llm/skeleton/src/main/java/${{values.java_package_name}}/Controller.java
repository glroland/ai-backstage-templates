package ${{values.java_package_name}};

import io.micrometer.common.util.StringUtils;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
