//
//  ChatCompletionChunkObject.swift
//
//
//  Created by James Rochabrun on 10/10/23.
//

import Foundation

/// Represents a [streamed](https://platform.openai.com/docs/api-reference/chat/streaming) chunk of a chat completion response returned by model, based on the provided input.
public struct ChatCompletionChunkObject: Decodable {
   
   /// A unique identifier for the chat completion chunk.
   public let id: String
   /// A list of chat completion choices. Can be more than one if n is greater than 1.
   public let choices: [ChatChoice]
   /// The Unix timestamp (in seconds) of when the chat completion chunk was created.
   public let created: Int
   /// The model to generate the completion.
   public let model: String
   /// This fingerprint represents the backend configuration that the model runs with.
   /// Can be used in conjunction with the seed request parameter to understand when backend changes have been made that might impact determinism.
   public let systemFingerprint: String?
   /// The object type, which is always chat.completion.chunk.
   public let object: String
   
   public struct ChatChoice: Decodable {
      
      /// A chat completion delta generated by streamed model responses.
      public let delta: Delta
      /// The reason the model stopped generating tokens. This will be stop if the model hit a natural stop point or a provided stop sequence, length if the maximum number of tokens specified in the request was reached, content_filter if content was omitted due to a flag from our content filters, tool_calls if the model called a tool, or function_call (deprecated) if the model called a function.
      public let finishReason: IntOrStringValue?
      /// The index of the choice in the list of choices.
      public let index: Int
      /// Provided by the Vision API.
      public let finishDetails: FinishDetails?
      
      public struct Delta: Decodable {
         
         /// The contents of the chunk message.
         public let content: String?
         /// The tool calls generated by the model, such as function calls.
         public let toolCalls: [ToolCall]?
         /// The name and arguments of a function that should be called, as generated by the model.
         @available(*, deprecated, message: "Deprecated and replaced by `tool_calls`")
         public let functionCall: FunctionCall?
         /// The role of the author of this message.
         public let role: String?
         
         enum CodingKeys: String, CodingKey {
            case content
            case toolCalls = "tool_calls"
            case functionCall = "function_call"
            case role
         }
      }
      
      /// Provided by the Vision API.
      public struct FinishDetails: Decodable {
         let type: String
      }
      
      enum CodingKeys: String, CodingKey {
         case delta
         case finishReason = "finish_reason"
         case index
         case finishDetails = "finish_details"
      }
   }
   
   enum CodingKeys: String, CodingKey {
      case id
      case choices
      case created
      case model
      case systemFingerprint = "system_fingerprint"
      case object
   }
}
