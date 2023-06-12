import 'package:meta/meta.dart';

import '../language_models/language_models.dart';
import '../prompts/models/models.dart';
import 'models/models.dart';

/// Chat models base class.
/// It should take in chat messages and return a chat message.
abstract class BaseChatModel
    extends BaseLanguageModel<ChatMessage, ChatGeneration> {
  const BaseChatModel();

  /// Runs the chat model on the given messages.
  ///
  /// - [messages] The messages to pass into the model.
  /// - [stop] Optional list of stop words to use when generating.
  ///
  /// Example:
  /// ```dart
  /// final result = chat.generate([ChatMessage.human('say hi!')]);
  /// ```
  @override
  Future<ChatResult> generate(
    final List<ChatMessage> messages, {
    final List<String>? stop,
  });

  /// Runs the chat model on the given prompt value.
  ///
  /// - [messages] The messages to pass into the model.
  /// - [stop] Optional list of stop words to use when generating.
  ///
  /// Example:
  /// ```dart
  /// final result = chat.generatePrompt(
  ///   ChatPromptValue([ChatMessage.human('say hi!')]),
  /// );
  /// ```
  @override
  Future<ChatResult> generatePrompt(
    final PromptValue promptValue, {
    final List<String>? stop,
  }) {
    return generate(promptValue.toChatMessages(), stop: stop);
  }

  /// Runs the chat model on the given messages.
  ///
  /// - [messages] The messages to pass into the model.
  /// - [stop] Optional list of stop words to use when generating.
  ///
  /// Example:
  /// ```dart
  /// final result = chat([HumanMessage(content: 'say hi!')]);
  /// ```
  Future<ChatMessage> call(
    final List<ChatMessage> messages, {
    final List<String>? stop,
  }) async {
    final ChatResult result = await generate(messages, stop: stop);
    return result.generations[0].output;
  }
}

/// [SimpleChatModel] provides a simplified interface for working with chat
/// models, rather than expecting the user to implement the full
/// [SimpleChatModel.generate] method.
abstract class SimpleChatModel extends BaseChatModel {
  const SimpleChatModel();

  @override
  Future<ChatResult> generate(
    final List<ChatMessage> messages, {
    final List<String>? stop,
  }) async {
    final text = await callInternal(messages, stop: stop);
    final message = ChatMessage.ai(text);
    return ChatResult(
      generations: [ChatGeneration(message)],
    );
  }

  /// Method which should be implemented by subclasses to run the model.
  @visibleForOverriding
  Future<String> callInternal(
    final List<ChatMessage> messages, {
    final List<String>? stop,
  });
}
