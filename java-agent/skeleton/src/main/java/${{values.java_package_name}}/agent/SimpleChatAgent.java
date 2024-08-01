package ${{values.java_package_name}}.agent;

import dev.langchain4j.service.SystemMessage;

interface SimpleChatAgent {
    @SystemMessage({
            "You are an agent specializing in retail products.",
            "If there a date convert it in a human readable format."
    })
    String chat(String userMessage);
}
