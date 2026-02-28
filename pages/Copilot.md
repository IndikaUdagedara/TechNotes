# Copilot

https://learn.microsoft.com/en-us/training/paths/copilot/

## Responsible AI

- AI can make decisions difficult to interpret
- Biased decisions
- Privacy violations

### Principles

https://learn.microsoft.com/en-us/training/modules/responsible-ai-with-github-copilot/3-six-principles-of-responsible-ai

- **Fairness:** AI systems should treat all people fairly.
- **Reliability and safety:** AI systems should perform reliably and safely.
- **Privacy and security:** AI systems should be secure and respect privacy.
- **Inclusiveness:** AI systems should empower everyone and engage people.
- **Transparency:** AI systems should be understandable.
- **Accountability:** People should be accountable for AI systems.


## Key features
- Chat (in IDE)
- PR summary
- Code Review Assistance
- CLI
- Spaces: Help with understanding a project
- Agent (in IDE)


## Plans

https://learn.microsoft.com/en-us/training/modules/introduction-to-github-copilot/2-github-copilot-your-ai-pair-programmer

### GitHub Copilot Free
- 2000 code completions per month
- 50 chat requests per month
- Access to advanced AI models (GPT-4o and Claude 3.5 Sonnet)
- Code completions in supported editors

### GitHub Copilot Pro
- Unlimited code completions and chat requests
- Priority access to latest AI models
- Advanced code suggestions and explanations
- Integration with supported IDEs (VS Code, Visual Studio, JetBrains, Neovim)
- Automated test generation and code explanation features

### GitHub Copilot Pro+
- All Pro features
- Additional premium request capacity
- Priority infrastructure access

### GitHub Copilot Business
- All Pro and Pro+ features for organization members
- Centralized management and policy controls
- Security vulnerability filtering
- Code referencing and public code filtering
- Chat in IDE and mobile
- IP indemnity and enterprise-grade security, safety, privacy

### GitHub Copilot Enterprise
- All Business features
- Personalized code suggestions based on internal/private code
- Integration with GitHub Enterprise Cloud
- AI-powered search and documentation generation across codebase
- Enhanced PR support with AI-powered tags and summaries
- Organization-wide customization and fine-tuning of Copilot models
- Deep integration with GitHub for chat and codebase exploration


## Code generation flow

Editor -> Proxy -> Toxicity filter -> LLM

Proxy: detect prompt injection
Toxicity filter: Remove inappropriate content and personal data

Generated code follows the same path in reverse.


It uses feedback to improve the model


## Prompt Engineering Techniques

### Principles (4 Ss)

https://learn.microsoft.com/en-us/training/modules/introduction-prompt-engineering-with-github-copilot/2-prompt-engineering-foundations-best-practices

- **Single:** Focus prompts on a single, well-defined task or question
- **Specific:** Use explicit and detailed instructions
- **Short:** Keep prompts concise and to the point while being specific
- **Surround:** Use descriptive filenames and keep related files open for context

### Best Practices

- **Provide clarity:** Make prompts explicit and single-focused (e.g., "Write a Python function to filter and return even numbers from a given list")
- **Provide context with details:** Enrich understanding with contextual information through comments, which helps Copilot make better suggestions
- **Provide examples:** Use concrete examples to clarify requirements and help Copilot understand patterns quickly
- **Assert and iterate:** Treat initial output as a starting point; refine with added details and examples rather than starting from scratch

### How Copilot Learns (Prompting Strategies)

- **Zero-shot learning:** Generate code without examples, relying on foundational training (good for common patterns)
- **One-shot learning:** Provide a single example to guide context-aware responses and maintain code standards
- **Few-shot learning:** Provide multiple examples to handle complex scenarios and edge cases with greater precision
- **Chain prompting:** For complex multi-step features, summarize context between turns to keep processing efficient (1 PRU per request vs. 2-3 PRU for full history)

### Role Prompting

Instruct Copilot to act as a specific expert for specialized tasks:

- **Security expert role:** "Act as a cybersecurity expert..." – generates code with input sanitization, attack protection, and OWASP guidelines
- **Performance optimization role:** "Act as a performance expert..." – produces optimized algorithms, memory-efficient code, and scalability considerations
- **Testing specialist role:** "Act as a testing specialist..." – creates comprehensive test coverage with edge cases and mock implementations


## Copilot Coding Agent

Autonomous assistant running on GitHub (not just IDE). Automates branch creation, commits, PR opening/descriptions for clearly scoped tasks like bug fixes, feature implementation, testing, documentation, and technical debt.

### Delegation methods
- Assign issues to Copilot (GitHub.com, Mobile, API/CLI)
- Request PR creation (Agents panel, Chat, IDE, MCP tools)
- Mention @copilot in PR comments to iterate

### vs. Traditional IDE assistants
- Work happens as GitHub commits (transparent, traceable)
- Automates branch/commit/PR workflow
- Asynchronous collaboration via PR review comments

### vs. Agent Mode (Copilot Edits)
- **Coding agent:** Autonomous GitHub environment → creates PRs
- **Agent Mode:** Local IDE edits in synchronous session

