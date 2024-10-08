package ${{values.java_package_name}}.util;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import org.apache.commons.lang3.StringUtils;

@Component
public class ConfigManager 
{
    private static final Log log = LogFactory.getLog(ConfigManager.class);
    
    @Autowired
    private Environment env;

    public static final String CONFIG_GROUP = "${{values.artifact_id}}";

    public static final String CONFIG_ENTRY_ENDPOINT = "inference-endpoint";
    public static final String CONFIG_ENTRY_APIKEY = "api-key";
    public static final String CONFIG_ENTRY_AGENT_MODEL_NAME = "agent-model-name";
    public static final String CONFIG_ENTRY_EMBEDDING_MODEL_NAME = "embedding-model-name";
    public static final String CONFIG_ENTRY_MAX_TOKENS = "max-tokens";
    public static final String CONFIG_ENTRY_TIMEOUT = "timeout-seconds";
    public static final String CONFIG_ENTRY_TEMP = "temperature";
    public static final String CONFIG_ENTRY_TOP_P = "top-p";
    public static final String CONFIG_ENTRY_EMBEDDINGS_DIMENSIONS = "embeddings-dimensions";
    public static final String CONFIG_ENTRY_DEFAULT_CHAT_MODEL = "default-chat-model";

    public static final String CHAT_MODEL_MISTRAL = "mistral";
    public static final String CHAT_MODEL_OPENAI = "openai";
    public static final String CHAT_MODEL_OLLAMA = "ollama";
    public static final String CHAT_MODEL_LOCALAI = "localai";

    public static final String AGENT_TYPE_SIMPLE = "simple";
    public static final String AGENT_TYPE_TOOL = "tool";

    private String getProperty(String propKey)
    {
        if(log.isDebugEnabled())
        {
            log.debug("Getting property from env: propKey = " + propKey);
        }
        return env.getProperty(propKey);
    }

    private String getValue(String chatModel, String propertyName)
    {
        // log every config lookup request
        if (log.isDebugEnabled())
        {
            log.debug("Config Lookup Request -- [chatModel=" + chatModel + "] [propertyName=" + propertyName + "]");
        }

        // order of precidence - chat model override first
        if (StringUtils.isNotEmpty(chatModel))
        {
            String value = getProperty(CONFIG_GROUP + "." + chatModel + "." + propertyName);
            if (value != null)
            {
                log.debug("Configured Value -- [" + chatModel + "] [propertyName=" + propertyName + "] [value=" + value + "]");                
                return value;
            }
        }
            
        // order of precidence - root override second
        String value = getProperty(CONFIG_GROUP + "." + propertyName);
        log.debug("Configured Value -- [DEFAULT] [propertyName=" + propertyName + "] [value=" + value + "] [FYI-RequestedModel=" + chatModel + "]");                
        return value;
    }

    public String getInferenceEndpoint()
    {
        return getInferenceEndpoint("");
    }

    public String getInferenceEndpoint(String chatModel)
    {
        return getValue(chatModel, CONFIG_ENTRY_ENDPOINT);
    }

    public String getInferenceApiKey()
    {
        return getInferenceApiKey("");
    }

    public String getInferenceApiKey(String chatModel)
    {
        return getValue(chatModel, CONFIG_ENTRY_APIKEY);
    }

    public String getAgentModelName()
    {
        return getAgentModelName("");
    }

    public String getAgentModelName(String chatModel)
    {
        return getValue(chatModel, CONFIG_ENTRY_AGENT_MODEL_NAME);
    }

    public String getEmbeddingModelName()
    {
        return getEmbeddingModelName("");
    }

    public String getEmbeddingModelName(String chatModel)
    {
        return getValue(chatModel, CONFIG_ENTRY_EMBEDDING_MODEL_NAME);
    }

    public Integer getMaxTokens()
    {
        return getMaxTokens("");
    }

    public Integer getMaxTokens(String chatModel)
    {
        String value = getValue(chatModel, CONFIG_ENTRY_MAX_TOKENS);
        if (value == null)
            return null;
        return Integer.valueOf(value);
    }

    public Integer getInferenceTimeout()
    {
        return getInferenceTimeout("");
    }

    public Integer getInferenceTimeout(String chatModel)
    {
        String value = getValue(chatModel, CONFIG_ENTRY_TIMEOUT);
        if (value == null)
            return null;
        return Integer.valueOf(value);
    }

    public Integer getEmbeddingsDimensions(String chatModel)
    {
        String value = getValue(chatModel, CONFIG_ENTRY_EMBEDDINGS_DIMENSIONS);
        if (value == null)
            return null;
        return Integer.valueOf(value);
    }

    public Double getTemperature()
    {
        return getTemperature("");
    }

    public Double getTemperature(String chatModel)
    {
        String value = getValue(chatModel, CONFIG_ENTRY_TEMP);
        if (value == null)
            return null;
        return Double.valueOf(value);
    }

    public Double getTopP()
    {
        return getTopP("");
    }

    public Double getTopP(String chatModel)
    {
        String value = getValue(chatModel, CONFIG_ENTRY_TOP_P);
        if (value == null)
            return null;
        return Double.valueOf(value);
    }

    public String getDefaultChatModel()
    {        
        String value = getValue(null, CONFIG_ENTRY_DEFAULT_CHAT_MODEL);
        if (value != null)
        {
            log.debug("Configured Value -- [" + CONFIG_ENTRY_DEFAULT_CHAT_MODEL + "] [value=" + value + "]");                
            return value;
        }

        log.warn("No configured default chat model.  Assuming OpenAI");
        return CHAT_MODEL_OPENAI;
    }
}
