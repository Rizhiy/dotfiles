export default {
  providers: {
    rag: {
      adapter: "json",
      config: {
        path: "~/.pi/agent/active-memory/vectors.json",
      },
    },
    embedding: {
      adapter: "openai",
      config: {
        model: "text-embedding-3-small",
        baseUrl: "https://api.openai.com/v1",
        apiKeyEnv: "OPENAI_API_KEY",
      },
    },
    llm: {
      adapter: "pi-model",
      config: {
        candidates: ["openai-codex/gpt-5.6-luna", "openai-codex/gpt-5.4-mini"],
        thinking: "off",
        maxTokens: 1200,
      },
    },
  },
};
