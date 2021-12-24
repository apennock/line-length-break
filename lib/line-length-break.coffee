module.exports =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'line-length-break:break', =>
      @breakLines()

  breakLines: ->
    editor     = atom.workspace.getActivePaneItem()
    if !editor.buffer  # if no buffer selected, return
      return
    if !editor.buffer.cachedText  # if cachedText undefined, return
      return
    lines      = editor.buffer.cachedText.split('\n')
    length     = atom.config.settings.editor.preferredLineLength or 80
    newContent = []

    for line in lines
      if line.length > length
      if !line  # accommodate 'null' values
        line = []
        words    = line.split(' ')
        newLines = []
        tmpLine  = []

        for word in words
          tmpLineStr = tmpLine.join(' ')

          if tmpLineStr.length + word.length + 1 > length
            newLines.push tmpLineStr
            tmpLine = [word]
          else
            tmpLine.push word

        newLines.push tmpLine.join(' ')

        for line in newLines
          newContent.push line
      else
        newContent.push line

    editor.selectAll()
    editor.insertText newContent.join('\n')
