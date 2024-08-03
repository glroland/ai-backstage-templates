"""${{values.artifact_id}}

${{values.description}}
"""
import streamlit as st
from openai import OpenAI

with st.sidebar:
    openai_api_url = st.text_input(label="OpenAI API URL",
                                   key="openai_api_url",
                                   value="http://envision:8000/v1")
    openai_api_model_name = st.text_input(label="Model Name",
                                          key="openai_api_model_name",
                                          value="vllm-service")
    openai_max_tokens = st.number_input(label="Max Tokens",
                                        min_value=1,
                                        max_value=10000,
                                        value=100,
                                        step=10)
    openai_temperature = st.number_input(label="Temperature",
                                         min_value=0.0,
                                         max_value=1.0,
                                         value=0.8,
                                         step=0.1)


st.title("💬 Chatbot (${{values.artifact_id}})")

if "messages" not in st.session_state:
    st.session_state["messages"] = [{"role": "assistant", "content": "How can I help you?"}]

for msg in st.session_state.messages:
    st.chat_message(msg["role"]).write(msg["content"])

if prompt := st.chat_input():
    client = OpenAI(base_url=openai_api_url,
                    api_key="api-key")
    st.session_state.messages.append({"role": "user", "content": prompt})
    st.chat_message("user").write(prompt)
    response = client.chat.completions.create(model=openai_api_model_name,
                                              messages=st.session_state.messages,
                                              max_tokens=openai_max_tokens,
                                              temperature=openai_temperature)
    msg = response.choices[0].message.content
    st.session_state.messages.append({"role": "assistant", "content": msg})
    st.chat_message("assistant").write(msg)
