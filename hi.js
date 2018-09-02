(function (hijs) {

var selector = hijs || 'code, div.lstlisting';

var keywords = ('fun begin if else receive end case where').split(' '),
    special  = ('module compile jsmacro js export author behaviour record define copyright include include_lib').split(' ');

var syntax = [
  ['comment', /(\/\*(?:[^*\n]|\*+[^\/*])*\*+\/)/g],
  ['comment', /(\%%[^\n]*)/g],
  ['record', /(\#[^{})']*)/g],
  ['string' , /("(?:(?!")[^\\\n]|\\.)*"|'(?:(?!')[^\\\n]|\\.)*')/g],
  ['regexp' , /(\/.+\/[mgi]*)(?!\s*\w)/g],
  ['class'  , /\b([A-Z][a-zA-Z]+)\b/g],
  ['number' , /\b([0-9]+(?:\.[0-9]+)?)\b/g],
  ['keyword', new(RegExp)('\\b(' + keywords.join('|') + ')\\b', 'g')],
  ['special', new(RegExp)('\\b(' + special.join('|') + ')\\b', 'g')]
];
var nodes, table = {};

nodes = document.querySelectorAll(selector);

for (var i = 0, children; i < nodes.length; i++) {
    children = nodes[i].childNodes;

    for (var j = 0, str; j < children.length; j++) {
        code = children[j];

        if (code.length >= 0) { // It's a text node
            // Don't highlight command-line snippets
            if (! /^\$\s/.test(code.nodeValue.trim())) {
                syntax.forEach(function (s) {
                    var k = s[0], v = s[1];
                    code.nodeValue = code.nodeValue.replace(v, function (_, m) {
                        return '\u00ab' + encode(k) + '\u00b7'
                                        + encode(m) +
                               '\u00b7' + encode(k) + '\u00bb';
                    });
                });
            }
        }
    }
}
for (var i = 0; i < nodes.length; i++) {
    nodes[i].innerHTML =
        nodes[i].innerHTML.replace(/\u00ab(.+?)\u00b7(.+?)\u00b7\1\u00bb/g, function (_, name, value) {
            value = value.replace(/\u00ab[^\u00b7]+\u00b7/g, '').replace(/\u00b7[^\u00bb]+\u00bb/g, '');
            return '<span class="' + decode(name) + '">' + escape(decode(value)) + '</span>';
    });
}

function escape(str) {
    return str.replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

// Encode ASCII characters to, and from Braille
function encode (str, encoded) {
    table[encoded = str.split('').map(function (s) {
        if (s.charCodeAt(0) > 127) { return s }
        return String.fromCharCode(s.charCodeAt(0) + 0x2800);
    }).join('')] = str;
    return encoded;
}
function decode (str) {
    if (str in table) {
        return table[str];
    } else {
        return str.trim().split('').map(function (s) {
            if (s.charCodeAt(0) - 0x2800 > 127) { return s }
            return String.fromCharCode(s.charCodeAt(0) - 0x2800);
        }).join('');
    }
}

})(window.hijs);
