<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Using Apple’s On-Device LLMs with the Foundation Models Framework on iOS

*A practical and deep-dive guide for Swift and Xcode developers, ready for copy-paste into your code editor, covering all you need to know before integrating Apple’s on-device Large Language Model and Foundation Models framework into your native iOS apps.*

## Table of Contents

- [Introduction](#introduction)
- [Device, OS, and Developer Requirements](#device-os-and-developer-requirements)
- [Apple Intelligence and Foundation Models Cheat Sheet](#apple-intelligence-and-foundation-models-cheat-sheet)
- [Project Setup](#project-setup)
- [Fundamental API Concepts](#fundamental-api-concepts)
    - [Model and Availability](#model-and-availability)
    - [Sessions and Context](#sessions-and-context)
    - [Prompting](#prompting)
    - [Structured Output with @Generable and @Guide](#structured-output-with-generable-and-guide)
    - [Tool Calling](#tool-calling)
- [Practical Example: Building a Simple LLM Chat in SwiftUI](#practical-example-building-a-simple-llm-chat-in-swiftui)
- [Advanced Practices](#advanced-practices)
    - [Streaming Responses](#streaming-responses)
    - [Session Prewarming](#session-prewarming)
    - [Guardrails and Safety](#guardrails-and-safety)
    - [Error Handling](#error-handling)
    - [Performance Tuning and Profiling](#performance-tuning-and-profiling)
- [Common Limitations and Best Practices](#common-limitations-and-best-practices)
- [FAQ/Troubleshooting](#faqtroubleshooting)
- [References and Learning Resources](#references-and-learning-resources)


## Introduction

The Foundation Models framework, introduced at WWDC25, gives every supported iOS, macOS, iPadOS, and visionOS app developer direct API access to the same ~3-billion-parameter large language model that powers Apple Intelligence features. This model runs locally on Apple Silicon, enabling privacy-preserving, low-latency, and cost-free AI-powered capabilities such as text generation, conversation, summarization, extraction, and dynamic tool invocation—all entirely on the user’s personal device[^1][^2][^3][^4][^5].

This readme provides an in-depth, code-first, *concise but exhaustive* reference for any Swift developer wishing to use Apple’s on-device LLM in a native iOS (or iPadOS, macOS, visionOS) project. It starts from the device requirements and project setup, walks you through the essential framework components, and illustrates advanced integration practices and robust error handling. By following this guide, you’ll move from zero to a privacy-first conversational AI-powered app, with pointers for advanced scenarios and best practices.

## Device, OS, and Developer Requirements

Before you start, make sure *every* requirement below is met:

- **Xcode**: Version 26 or newer, running on macOS Tahoe (Sequoia won’t work)[^1][^6].
- **iPhone/iPad/Mac/visionOS Hardware**: Must be on the list of Apple Intelligence supported devices:
    - iPhone 15 Pro/Pro Max, iPhone 16 (all)
    - iPad mini (A17 Pro), Any iPad with M1 or later, Any Mac with M1 or later
    - Apple Vision Pro[^7][^6][^8][^9][^10]
- **OS Version**: iOS 18.1+, iPadOS 18.1+, macOS Sequoia 15.1+/Tahoe 26.0+, visionOS 2.4+
- **Apple Intelligence Activated** (System Settings > Apple Intelligence \& Siri > Turn On)[^11][^8][^9][^10]
- **Siri/Device Language** set to a supported language (initially English US, French, German, Italian, Portuguese (Brazil), Spanish, Japanese, Korean, Chinese(Simplified))[^8][^10]
- **Storage Space**: 7+ GB free (for model assets)[^8][^9][^10]
- **Physical Device**: On-device LLMs do *not* run on simulator[^12][^13]
- **Internet (one-time)**: Model downloads on activation; after that, can work offline[^8][^9].


## Apple Intelligence and Foundation Models Cheat Sheet

**Why Use This?**

- ***Privacy***: All inference occurs on device—data never leaves hardware[^1][^14][^7][^3][^5].
- ***Zero API Costs***: No cloud fees or quota. Unlimited queries. No app size increase—the model is bundled with the OS.
- ***Low Latency/Efficiency***: ~0.6ms first token, generates at ~30 tokens/sec on iPhone 15 Pro[^1][^7][^2].
- ***Swift-Native API***: Deep integration with Swift, SwiftUI, concurrency, macros, and instruments.

**Core Capabilities:**

- Text/question answering, summarization, tagging, extraction, sentiment analysis.
- Type-safe Swift object output via macros.
- Safe, context-aware tool invocation (weather, contacts, custom tools)[^14][^4][^5].


## Project Setup

1. **Create Your Xcode Project**
    - Open Xcode 26, start a new SwiftUI App project (recommended for modern iOS projects).
2. **Enable Apple Intelligence on your Device**
    - Update to iOS 18.1+ (settings > General > Software Update)[^8][^9][^10].
    - Enable Apple Intelligence under Settings > Apple Intelligence \& Siri > Turn On.
    - Ensure Siri and device language are both set to English (USA or a supported market)[^8][^9][^10][^11].
3. **Import the Foundation Models Framework**

```swift
import FoundationModels
```

    - No CocoaPods/Swift Package Manager required; the framework is embedded in the OS.
4. **Check Model Availability**
    - The Foundation Model will only work on devices where it’s available and ready. Always check before you show any LLM UI.

## Fundamental API Concepts

### Model and Availability

- **SystemLanguageModel** exposes the on-device foundation LLM. *Always* check its status before using.

```swift
let model = SystemLanguageModel.default

switch model.availability {
  case .available:
    print("LLM Ready!")
  case .unavailable(let reason):
    // See Table below for handling reasons
    print("LLM Unavailable: \(reason)")
}
```

*Common Unavailable Reasons*:


| Reason | What It Means |
| :-- | :-- |
| .deviceNotEligible | Device not new enough (no Apple Silicon / A17 Pro+) |
| .appleIntelligenceNotEnabled | User turned off Apple Intelligence or wrong language/settings |
| .modelNotReady | Model still downloading or initializing |
| .notReady | System constrained (e.g., battery, Game Mode) |
| _ | Unknown |

*ALWAYS* surface a helpful message to users when unavailable.

### Sessions and Context

- **LanguageModelSession**: Handles your conversation "session"—the context window, transcript, and all LLM calls[^1][^14][^3][^4][^5].

```swift
let session = LanguageModelSession()
```

You can also initialize with:

- specific model (including adapters for tagging tasks)
- guardrails (for stricter safety)
- custom instructions (define the "persona" of the model response)
- tools (see below)
- A session keeps track of all prompts and model outputs in a *transcript*. When the session ends, so does the conversational context.


### Prompting

- **Prompt**: Simple wrapper for your user question, ready for LLM consumption.

```swift
let prompt = Prompt("What's the weather in New York today?")
let response = try await session.respond(to: prompt)
print(response.content)
```

- **Instructions**: (Optional) System-level directions that tell the model *how* to behave during the session. Instructions are not user-controlled and help shield from prompt injection.

```swift
let instructions = Instructions("You are a helpful assistant. Respond concisely.")
let session = LanguageModelSession(instructions: instructions)
```

- **Transcript**: Contains all prior user/model turns for context.
- **GenerationOptions**: Fine-tune output randomness, max tokens, etc.

```swift
let options = GenerationOptions(temperature: 0.7, maxTokens: 256)
let response = try await session.respond(to: prompt, options: options)
```


### Structured Output with @Generable and @Guide

*Ordinary LLMs can hallucinate formats. Apple’s LLM supports guided generation and schema-constrained outputs, all in native Swift*.

- **@Generable**: Attach this macro to a `struct` or `enum` to make the model generate a *type-safe Swift object* as output[^14][^4][^5].

```swift
@Generable
struct BookRecommendation {
    @Guide(description: "The book's title (concise)")
    let title: String
    @Guide(description: "The author's name")
    let author: String
    @Guide(description: "Star rating (1-5)", min: 1, max: 5)
    let rating: Int
}
let response = try await session.respond(generating: BookRecommendation.self, to: prompt)
print(response.content.title)
```

- **@Guide**: Add constraints, range, and natural language hints to individual properties[^14][^4].


### Tool Calling

**Tool Calling** allows your app’s LLM to *autonomously* call custom Swift methods to fetch data or perform in-app actions (e.g., live weather, contacts, business logic), extending its capabilities *beyond its training cutoff*.

```swift
struct WeatherTool: Tool {
    let name = "fetchWeather"
    let description = "Get the current weather for a city."

    @Generable
    struct Arguments {
        let city: String
    }

    func call(arguments: Arguments) async throws -> ToolOutput {
        // Replace with real API logic
        if arguments.city.lowercased() == "paris" {
            return .string("22°C, Sunny")
        }
        return .string("Weather data unavailable")
    }
}
let tools = [WeatherTool()]
let session = LanguageModelSession(tools: tools)
```

The LLM will autonomously call `WeatherTool` if your prompt is relevant. *Tool calls are sandboxed for privacy and security.*

## Practical Example: Building a Simple LLM Chat in SwiftUI

Here is a distilled implementation of a basic chat-style assistant using Apple’s on-device LLM:

```swift
import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var input: String = ""
    @State private var output: String = ""
    @State private var loading: Bool = false
    private let model = SystemLanguageModel.default

    var body: some View {
        VStack(spacing: 20) {
            if model.availability == .available {
                TextField("Ask anything...", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                if loading {
                    ProgressView("Thinking...")
                }
                Button("Send") {
                    Task {
                        loading = true
                        await runPrompt()
                        loading = false
                    }
                }
                .disabled(loading || input.isEmpty)
                ScrollView {
                    Text(output)
                        .padding()
                }
            } else {
                Text("LLM Unavailable:\n\(unavailableReasonText())")
                    .foregroundColor(.red)
            }
        }.padding()
    }

    private func unavailableReasonText() -> String {
        switch model.availability {
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:
                return "This device is not eligible for Apple Intelligence."
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligence is not enabled. Check system settings."
            case .modelNotReady:
                return "Model is downloading or initializing – please wait."
            default:
                return "Model unavailable for an unknown reason."
            }
        default:
            return ""
        }
    }

    private func runPrompt() async {
        let session = LanguageModelSession()
        do {
            let response = try await session.respond(to: Prompt(input))
            await MainActor.run { output = response.content }
        } catch {
            await MainActor.run { output = "Error: \(error.localizedDescription)" }
        }
    }
}
```

This demonstrates:

- Availability checking and error reporting.
- Stateless, isolated LLM session per prompt (suitable for single-turn chat).
- Asynchronous prompt execution.


## Advanced Practices

### Streaming Responses

Instead of waiting for the whole answer, stream the response token-by-token (great for conversational UIs):

```swift
let session = LanguageModelSession()
let prompt = Prompt("Tell me a joke about programmers.")

do {
    var streamedResult = ""
    for try await token in session.streamResponse(to: prompt) {
        streamedResult += token
        print(streamedResult) // Update your UI here
    }
} catch {
    print("Error while streaming: \(error)")
}
```

With guided generation, use `.streamResponse(generating:MyStruct.self,to:prompt)` to receive progressive structured objects.

### Session Prewarming

To minimize initial inference latency, *prewarm* your `LanguageModelSession` class. Prewarming loads weights and context into memory before the first user request is made.

```swift
let session = LanguageModelSession()
await session.prewarm()
```

Prewarm whenever user intent to use AI features seems imminent (i.e., on feature tab open, not app launch).

### Guardrails and Safety

Apple enforces robust guardrails at multiple levels:

- Built-in model RLHF and blocklisting
- Optional session-level guardrails: `.strict` or `.standard`
- Streaming-level token moderation (e.g., cut off output if policy violation detected)[^1][^14][^15].

You can enable stricter moderation at session creation:

```swift
let session = LanguageModelSession(guardrails: .strict)
```

For custom moderation or to terminate/modify output mid-stream, inspect tokens as they arrive in streaming mode.

### Error Handling

Be ready for multiple error branches:

- **Model unavailable**: Most common on ineligible devices, or not-yet-initialized models.
- **Context window exceeded**: If the session transcript becomes too long (~4k tokens as of writing), you must create a new session.
- **Guardrail violation**: Input or output blocked per policy.
- **Unsupported language**: If asked to process a language not yet available.
Surface user-friendly messages, and (optionally) offer fallback cloud LLM support if required for coverage.


### Performance Tuning and Profiling

- Run all performance tests on physical devices—simulators do not support Apple Foundation Models or accurately reflect performance[^1][^12].
- Use Xcode’s Foundation Models Instrument for latency, load time, and resource profiling.
- Minimize context window churn; prune old entries or summarize to remain under window budget.
- For creative use cases, adjust `temperature` higher (e.g. 0.9+). For deterministic completion, lower it (near zero).


## Common Limitations and Best Practices

**What the On-Device LLM *Can* Do:**

- Generate and summarize text, answer questions, extract entities, classify, tag, sentiment analysis, perform simple natural conversation, call trusted Swift tools, generate Swift data models.
- Work offline, instantaneously, without sending any user data to the cloud.

**What it *Cannot* Do:**

- Is not a general world-knowledge chatbot—does not match GPT-4, Claude, Gemini in knowledge size[^4][^16].
- No images or non-text outputs (yet—vision and multimodal coming).
- Does not currently run custom models outside Apple’s chosen Foundation Models without adapters or system updates.
- Only runs on recent, high-end Apple silicon devices, and is tightly bound to OS release cadence.

**Best Practices:**

- Design graceful fallback for users on older or unsupported devices.
- Clearly disclose when a user prompt has not been answered by AI due to a rejection, error, or limitation.


## FAQ/Troubleshooting

**Q:** My device says “Model is unavailable”. What do I do?

- A: Confirm you are running iOS 18.1+ (or equivalent macOS/iPadOS/visionOS version) on eligible hardware, with Apple Intelligence *enabled* and enough storage[^8][^9][^10].
- If language is unsupported, change both Siri and device language to English (Settings>General>Language \& Region).

**Q:** How does Apple guarantee privacy?

- All inference runs locally on-chip. User data never leaves the device for LLM requests. For escalated tasks routed to cloud, Apple’s Private Cloud Compute is end-to-end encrypted and designed for auditability and “privacy moat” guarantees[^7][^4][^16][^9].

**Q:** How do I update for new models/features?

- Models and the FoundationModels framework itself are upgraded via OTAs in iOS/macOS—no manual update steps required, but always check the current SDK documentation for breaking changes before releasing production apps.


## References and Learning Resources

- [Apple Developer Foundation Models Documentation][^6]
- [Apple Machine Learning Research Introduction][^7]
- [WWDC25 Foundation Models Video][^5][^14][^17]
- [Official Apple Newsroom: Foundation Models and Apple Intelligence][^18]
- [AppCoda’s Practical Tutorial][^1]
- [Maxfynn’s Foundation Models Playgrounds (Github)][^19]
- [rudrankriyam’s Sample AI App (Github)][^20]
- [Superwall Foundation Models Intro][^3]
- [Apple Support: How to get Apple Intelligence][^8][^9][^10]
- [Apple Research Blog: Model Architecture][^4][^16]
- [iosfeeds.com Getting Started Guide][^21]
- [Artem Novichkov’s Deep Dive][^22]

**Now you have all the essentials and advanced workflows to build, test, and deploy privacy-first, performant, Apple-native AI apps using on-device LLMs and the Foundation Models framework. Happy building!**

> *All code and guidance up to date as of iOS 18.1 / macOS Tahoe 26.0 (July 2025). Always reference the latest Apple Documentation and WWDC session videos for updates and deeper integration details.*

<div style="text-align: center">⁂</div>

[^1]: https://www.appcoda.com/foundation-models/

[^2]: https://gist.github.com/pj4533/9d196763f2b80bc01b40fc66ba4d1c63

[^3]: https://superwall.com/blog/an-introduction-to-apples-foundation-model-framework

[^4]: https://machinelearning.apple.com/research/apple-foundation-models-2025-updates

[^5]: https://www.youtube.com/watch?v=mJMvFyBvZEk

[^6]: https://developer.apple.com/documentation/foundationmodels

[^7]: https://machinelearning.apple.com/research/introducing-apple-foundation-models

[^8]: https://support.apple.com/en-in/121115

[^9]: https://support.apple.com/en-us/121115

[^10]: https://support.apple.com/en-ca/121115

[^11]: https://www.youtube.com/watch?v=TkmioAcp93s

[^12]: https://www.youtube.com/watch?v=_deDjujIi6A

[^13]: https://www.youtube.com/watch?v=wl0vZrQ5J9Q

[^14]: https://developer.apple.com/videos/play/wwdc2025/286/

[^15]: https://hogonext.com/how-to-debug-foundation-model-failures/

[^16]: https://www.deeplearning.ai/the-batch/apple-updates-its-on-device-and-cloud-ai-models-introduces-a-new-developer-api/

[^17]: https://developer.apple.com/videos/play/wwdc2025/286/?time=688

[^18]: https://www.apple.com/in/newsroom/2025/06/apple-supercharges-its-tools-and-technologies-for-developers/

[^19]: https://github.com/Maxfynn/Foundation-Models-Playgrounds

[^20]: https://github.com/rudrankriyam/Foundation-Models-Framework-Example

[^21]: https://iosfeeds.com/read/26501

[^22]: https://www.artemnovichkov.com/blog/getting-started-with-apple-foundation-models

[^23]: image.jpg

[^24]: image.jpg

[^25]: Screenshot-2025-07-15-at-4.38.03-PM.jpg

[^26]: https://dev.to/tattn/localllmclient-a-swift-package-for-local-llms-using-llamacpp-and-mlx-1bcp

[^27]: https://www.youtube.com/watch?v=7QSaqh5884k

[^28]: https://github.com/adhamtaha13/Foundation-Models-Framework-Example

[^29]: https://huggingface.co/blog/swift-coreml-llm

[^30]: https://www.reddit.com/r/iOSProgramming/comments/1la7o9r/foundation_models_framework_examples/

[^31]: https://www.linkedin.com/pulse/integrating-large-language-models-llms-ios-simple-guide-schumacher-rsree

[^32]: https://www.youtube.com/watch?v=6Wgg7DIY29E

[^33]: https://gist.github.com/awni/fe4f96c21ead68e60191190cbc1c129b

[^34]: https://github.com/PacktPublishing/iOS-18-Programming-for-Beginners-Ninth-Edition

[^35]: https://gist.github.com/szmeku/82475128388e90d434805c1c06eee35c

[^36]: https://www.reddit.com/r/iOSProgramming/comments/1lt63ou/hoping_to_get_some_help_with_foundation_models/

[^37]: https://azamsharp.com/2025/06/18/the-ultimate-guide-to-the-foundation-models-framework.html

[^38]: https://swift.org/blog/mlx-swift/

[^39]: https://www.youtube.com/watch?v=zrUcO7E7HVU

[^40]: https://pub.dev/documentation/foundation_models_framework/latest/

[^41]: https://www.youtube.com/watch?v=Qd6jc162MQQ

[^42]: https://blog.csdn.net/gitblog_00866/article/details/148574689

[^43]: https://www.youtube.com/watch?v=zVXhQFS6KIQ

[^44]: https://aws.amazon.com/what-is/foundation-models/

[^45]: https://matoffo.com/foundation-models-fmops-best-practices/

[^46]: https://www.youtube.com/watch?v=ZUxLbEH3-JA

[^47]: https://arxiv.org/html/2407.08176v1

[^48]: https://help.sap.com/docs/sap-ai-core/sap-ai-core-service-guide/foundation-model-tutorials

[^49]: https://www.youtube.com/watch?v=F2tXw74fyxc

[^50]: https://www.ibm.com/think/insights/ai-governance-foundation-models

[^51]: https://arxiv.org/pdf/2407.08176.pdf

[^52]: https://www.markovml.com/blog/foundational-models

[^53]: https://support.apple.com/en-bw/121115

[^54]: https://wwdcnotes.com/documentation/wwdcnotes/wwdc25-286-meet-the-foundation-models-framework/

[^55]: https://www.techtarget.com/whatis/feature/Foundation-models-explained-Everything-you-need-to-know

[^56]: https://www.avanderlee.com/swift/macros/

[^57]: https://nstudio.io/blog/stream-ai-responses-ios-26-foundationmodels

[^58]: https://stackoverflow.com/questions/45785458/swift-urlsessionconfiguration

[^59]: https://betterprogramming.pub/swift-macros-4f32e33ccf19

[^60]: https://dev.to/distalx/apples-foundation-models-framework-a-closer-look-jf2

[^61]: https://www.kodeco.com/ios/paths/apple-ai-models/45437626-translation-framework/03-advanced-translation-control-with-translationsession/04

[^62]: https://github.com/krzysztofzablocki/Swift-Macros

[^63]: https://lu.ma/nykyyhzx

[^64]: https://livsycode.com/swiftui/exploring-the-generable-and-guide-macros-in-foundationmodels/

[^65]: https://github.com/argmaxinc/whisperkit/blob/main/Sources/WhisperKit/Core/Configurations.swift

[^66]: https://github.com/ml-explore/mlx-swift-examples/blob/main/Libraries/MLXLLM/LLMModelFactory.swift

[^67]: https://github.com/pitt500/SwiftAndTipsMacros

[^68]: https://quickbirdstudios.com/blog/swift-macros/

[^69]: https://developer.apple.com/documentation/foundationmodels/languagemodelsession

[^70]: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/

[^71]: https://developer.apple.com/videos/play/wwdc2025/286/?time=175

[^72]: https://stackoverflow.com/questions/77879557/urls-in-ios-17s-new-speech-recognition-api-preparecustomlanguagemodel-vs-confi

[^73]: https://stackoverflow.com/questions/64379775/how-to-add-a-coreml-model-into-a-swift-package

