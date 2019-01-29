; ^!ahk
; Script Function:
;   Renumbers filenames. Good for playlists.

#Include, Explorer.ahk
#NoEnv
#SingleInstance, force
SendMode, Input

#IfWinActive, ahk_exe Explorer.EXE
; Number all files in folder
^P::
    currFolder := Explorer_GetPath()
    MsgBox, 1, Filenumbering, Number all files in %currFolder%?
    IfMsgBox, Ok
    {
        i := 1
        window := Explorer_GetWindow()
        for item in window.document.Folder.Items
        {
            filepath := item.path
            SplitPath, filepath, filename, filedir, fileext
            
            ; Don't rename folders
            If (fileext)
            {
                prefix := SubStr("000" . i, -2)
                FileMove, %filepath%, %filedir%\%prefix%_%filename%
                i++
            }
        }
    }
    Return

^/::
    window := Explorer_GetWindow()
    selected := window.document.SelectedItems
    i := 1
    for item in selected
    {
        current_filepath := item.path
        SplitPath, current_filepath, current_filename, current_dir, current_ext
        if (!current_ext)
            Continue

        if (i = 1)
        {
            filepath1 := current_filepath
            filename1 := current_filename
            prefix1 := SubStr(current_filename, 1, 3)
        }
        else if (i = 2)
        {
            prefix2 := SubStr(current_filename, 1, 3)
            new_currentfilename := prefix1 . SubStr(current_filename, 4)
            new_prevfilename := prefix2 . SubStr(filename1, 4)

            FileMove, %current_filepath%, %current_dir%\%new_currentfilename%
            FileMove, %filepath1%, %current_dir%\%new_prevfilename%
            Return
        }
        else
            Return
        i++
    }
    Return

^left::
    current_filepath := Explorer_GetSelected()
    SplitPath, current_filepath, current_filename, current_dir, current_ext
    If (current_ext)
    {
        current_prefix := SubStr(current_filename, 1, 3)
        window := Explorer_GetWindow()

        for item in window.document.Folder.Items
        {
            temp := item.path
            SplitPath, temp,,, ext
            If (!ext)
                Continue

            If (item.path = current_filepath)
            {
                SplitPath, prev_filepath, prev_filename
                
                prev_prefix := SubStr(prev_filename, 1, 3)
                new_currentfilename := prev_prefix . SubStr(current_filename, 4)
                new_prevfilename := current_prefix . SubStr(prev_filename, 4)

                FileMove, %current_filepath%, %current_dir%\%new_currentfilename%
                FileMove, %prev_filepath%, %current_dir%\%new_prevfilename%
                Return
            }
            Else
            {
                prev_filepath := temp
            }
        }
    }
    Return

^right::
    current_filepath := Explorer_GetSelected()
    SplitPath, current_filepath, current_filename, current_dir, current_ext
    If (current_ext)
    {
        current_prefix := SubStr(current_filename, 1, 3)

        window := Explorer_GetWindow()
        found := False

        for item in window.document.Folder.Items
        {
            If (found)
            {
                next_filepath := item.path
                SplitPath, next_filepath, next_filename,, next_ext
                If (!next_ext)
                    Continue
                
                next_prefix := SubStr(next_filename, 1, 3)
                new_currentfilename := next_prefix . SubStr(current_filename, 4)
                new_nextfilename := current_prefix . SubStr(next_filename, 4)

                FileMove, %current_filepath%, %current_dir%\%new_currentfilename%
                FileMove, %next_filepath%, %current_dir%\%new_nextfilename%
                Return
            }
            If (item.path = current_filepath)
            {
                found := True
            }
        }
    }
    Return


#IfWinActive