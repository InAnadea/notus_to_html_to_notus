import 'package:html/parser.dart';
import 'package:zefyrka/zefyrka.dart';

class HtmlToNotus {
  static NotusDocument getNotusFromHtml(var text) {
    final document = NotusDocument();
    var data = parse(text.toString().replaceAll('\n', '')).body;
    if (data == null) {
      return document;
    }
    if (data.nodes.isEmpty) return document;
    document.replace(0, document.length, '');
    for (int i = 0; i < data.nodes.length; i++) {
      if (data.nodes[i].toString().contains('<html h1>')) {
        LineNode line = LineNode();
        line.add(LeafNode(data.nodes[i].text!.replaceAll('\n', '')));
        line.applyAttribute(NotusAttribute.h1);
        document.root.add(line);
      } else if (data.nodes[i].toString().contains('<html h2>')) {
        LineNode line = LineNode();
        line.add(LeafNode(data.nodes[i].text!.replaceAll('\n', '')));
        line.applyAttribute(NotusAttribute.h2);
        document.root.add(line);
      } else if (data.nodes[i].toString().contains('<html p>')) {
        LineNode line = LineNode();
        line = _formatParagraph(data.nodes[i]);
        document.root.add(line);
      } else if (data.nodes[i].toString().contains('<html ul>')) {
        BlockNode block = BlockNode();
        block = _formatBlock(data.nodes[i], NotusAttribute.block.bulletList);
        document.root.add(block);
      } else if (data.nodes[i].toString().contains('<html ol>')) {
        BlockNode block = BlockNode();
        block = _formatBlock(data.nodes[i], NotusAttribute.block.numberList);
        document.root.add(block);
      } else if (data.nodes[i].toString().contains('<html s>')) {
        LineNode line = LineNode();
        line = _formatParagraph(data.nodes[i]);
        document.root.add(line);
      }
    }
    return document;
  }

  static _getChildrenAttributes(var node) {
    List<String> attributes = [];
    for (var child in node.children) {
      attributes.addAll(_getChildrenAttributes(child));
    }

    if (node.toString().contains('<html b>')) {
      attributes.add('b');
    } else if (node.toString().contains('<html u>')) {
      attributes.add('u');
    } else if (node.toString().contains('<html i>')) {
      attributes.add('i');
    } else if (node.toString().contains('<html s>')) {
      attributes.add('s');
    }

    return attributes;
  }

  static _formatParagraph(var line) {
    LineNode lineNode = LineNode();
    for (int j = 0; j < line.nodes.length; j++) {
      LeafNode leaf = LeafNode(line.nodes[j].text);
      List<String> attributes = _getChildrenAttributes(line.nodes[j]);
      if (attributes.contains('b')) {
        leaf.applyAttribute(NotusAttribute.bold);
      }
      if (attributes.contains('u')) {
        leaf.applyAttribute(NotusAttribute.underline);
      }
      if (attributes.contains('i')) {
        leaf.applyAttribute(NotusAttribute.italic);
      }
      if (attributes.contains('s')) {
        leaf.applyAttribute(NotusAttribute.strikethrough);
      }
      lineNode.add(leaf);
    }
    return lineNode;
  }

  static _formatBlock(var line, NotusAttribute attribute) {
    BlockNode block = BlockNode();
    block.applyAttribute(attribute);
    for (int j = 0; j < line.nodes.length; j++) {
      if (line.nodes[j].toString().contains('<html li>')) {
        LineNode lineNode = LineNode();
        lineNode = _formatParagraph(line.nodes[j]);
        block.add(lineNode);
      }
    }
    return block;
  }
}
