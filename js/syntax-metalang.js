CodeMirror.defineMode('metalang', function(config) {

  var words = {
    'true': 'atom',
    'false': 'atom',
    'def': 'keyword',
    'if': 'keyword',
    'then': 'keyword',
    'else': 'keyword',
    'elsif': 'keyword',
    'for': 'keyword',
    'to': 'keyword',
    'while': 'keyword',
    'do': 'keyword',
    'type': 'keyword',
    'record': 'keyword',
    'with': 'keyword',
    'try': 'keyword',
    'end': 'keyword',
    'main': 'keyword',
    'return': 'keyword',
    'int': 'builtin',
    'string': 'builtin',
    'bool': 'builtin',
    'char': 'builtin',
    'array': 'builtin',
    'skip': 'builtin',
    'read': 'builtin',
    'print': 'builtin',
  };

  function tokenBase(stream, state) {
    var sol = stream.sol();
    var ch = stream.next();

    if (ch === '"') {
      state.tokenize = tokenString;
      return state.tokenize(stream, state);
    }
    if (ch === '(') {
      if (stream.eat('*')) {
        state.commentLevel++;
        state.tokenize = tokenComment;
        return state.tokenize(stream, state);
      }
    }
    if (ch === '~') {
      stream.eatWhile(/\w/);
      return 'variable-2';
    }
    if (ch === '`') {
      stream.eatWhile(/\w/);
      return 'quote';
    }
    if (/\d/.test(ch)) {
      stream.eatWhile(/[\d]/);
      if (stream.eat('.')) {
        stream.eatWhile(/[\d]/);
      }
      return 'number';
    }
    if ( /[+\-*&%=<>!?|]/.test(ch)) {
      return 'operator';
    }
    stream.eatWhile(/\w/);
    var cur = stream.current();
    return words[cur] || 'variable';
  }

  function tokenString(stream, state) {
    var next, end = false, escaped = false;
    while ((next = stream.next()) != null) {
      if (next === '"' && !escaped) {
        end = true;
        break;
      }
      escaped = !escaped && next === '\\';
    }
    if (end && !escaped) {
      state.tokenize = tokenBase;
    }
    return 'string';
  };

  function tokenComment(stream, state) {
    var prev, next;
    while(state.commentLevel > 0 && (next = stream.next()) != null) {
      if (prev === '/' && next === '*') state.commentLevel++;
      if (prev === '*' && next === '/') state.commentLevel--;
      prev = next;
    }
    if (state.commentLevel <= 0) {
      state.tokenize = tokenBase;
    }
    return 'comment';
  }

  return {
    startState: function() {return {tokenize: tokenBase, commentLevel: 0};},
    token: function(stream, state) {
      if (stream.eatSpace()) return null;
      return state.tokenize(stream, state);
    }
  };
});

CodeMirror.defineMIME('text/x-metalang', 'metalang');
