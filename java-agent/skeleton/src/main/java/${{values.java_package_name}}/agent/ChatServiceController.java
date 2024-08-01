package ${{values.java_package_name}}.agent;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ${{values.java_package_name}}.util.ChatLanguageModelFactory;

import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.service.AiServices;
import org.apache.commons.lang3.StringUtils;

@RestController
public class ChatServiceController 
{
    private static final Log log = LogFactory.getLog(ChatServiceController.class);

    @Autowired
    private ChatLanguageModelFactory chatLanguageModelFactory;

    @PostMapping("/chat")
    public String chat(@RequestParam(value = "userMessage", defaultValue = "What is the current date and time?") 
                        String userMessage)
    {
        ChatLanguageModel chatLanguageModel = chatLanguageModelFactory.createDefault();

        SimpleChatAgent agent = AiServices.builder(SimpleChatAgent.class)
                .chatLanguageModel(chatLanguageModel)
                .chatMemory(MessageWindowChatMemory.withMaxMessages(10))
                .build();
        
        String answer = agent.chat(userMessage);
        log.info("User Message = '" + userMessage + "'  Response = '" + answer + "'");

        return answer;
    }
}
