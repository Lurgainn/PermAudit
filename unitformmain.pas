{-------------------------------------------------------------------------------

PermAudit : a simple GUI to use bfs/find command for search by permissions
Copyright (C)derSoft 2024

                        ---------- 000 ----------

This file is part of PermAudit.

PermAudit is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.

PermAudit is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
PermAudit. If not, see <https://www.gnu.org/licenses/>.

-------------------------------------------------------------------------------}

unit UnitFormMain;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
    EditBtn, Buttons, IniPropStorage, Grids, Menus, UniqueInstance, uPoweredby,
    usplashabout, ueled, RTTICtrls, Process, Types, StrUtils, unit_form_about,
    unit_form_help;

type

    { TformMain }

    TformMain = class(TForm)
        buttonHelp: TBitBtn;
        buttonExit: TBitBtn;
        buttonAbout: TBitBtn;
        buttonSetPermissions: TBitBtn;
        buttonSelectExecute: TBitBtn;
        checkSelectAll: TCheckBox;
        checkSelectAnd: TCheckBox;
        checkSelectGroupExec: TCheckBox;
        checkSetPermGroupExec: TCheckBox;
        checkSelectGroupExecAnd: TCheckBox;
        checkSetPermGroupGuid: TCheckBox;
        checkSelectGroupGuidAnd: TCheckBox;
        checkSetPermGroupRead: TCheckBox;
        checkSelectGroupReadAnd: TCheckBox;
        checkSetPermGroupWrite: TCheckBox;
        checkSelectGroupWriteAnd: TCheckBox;
        checkSelectNotAnd: TCheckBox;
        checkSelectOtherExec: TCheckBox;
        checkSetPermOtherExec: TCheckBox;
        checkSelectOtherExecAnd: TCheckBox;
        checkSetPermOtherRead: TCheckBox;
        checkSelectOtherReadAnd: TCheckBox;
        checkSelectOtherSticky: TCheckBox;
        checkSelectGroupRead: TCheckBox;
        checkSelectOtherRead: TCheckBox;
        checkSetPermOtherSticky: TCheckBox;
        checkSelectOtherStickyAnd: TCheckBox;
        checkSelectOtherWrite: TCheckBox;
        checkSetPermOtherWrite: TCheckBox;
        checkSelectOtherWriteAnd: TCheckBox;
        checkSetPermOwnerExec: TCheckBox;
        checkSelectOwnerExecAnd: TCheckBox;
        checkSetPermOwnerRead: TCheckBox;
        checkSelectOwnerReadAnd: TCheckBox;
        checkSelectOwnerSuid: TCheckBox;
        checkSelectOwnerExec: TCheckBox;
        checkSelectGroupGuid: TCheckBox;
        checkSetPermOwnerSuid: TCheckBox;
        checkSelectOwnerSuidAnd: TCheckBox;
        checkSelectOwnerWrite: TCheckBox;
        checkSelectNot: TCheckBox;
        checkSelectOwnerRead: TCheckBox;
        checkSelectGroupWrite: TCheckBox;
        checkSetPermOwnerWrite: TCheckBox;
        checkSelectOwnerWriteAnd: TCheckBox;
        directoryFind: TDirectoryEdit;
        editExclude: TEdit;
        IniPropStorage: TIniPropStorage;
        labelExcluded: TLabel;
        labelCount: TLabel;
        labelSelectGroup: TLabel;
        labelSetPermGroup: TLabel;
        labelSelectGroupAnd: TLabel;
        labelSelectOther: TLabel;
        labelSetPermOther: TLabel;
        labelSelectOtherAnd: TLabel;
        labelSelectOwner: TLabel;
        labelDirectory: TLabel;
        labelCommand: TLabel;
        labelSetPermOwner: TLabel;
        labelSelectOwnerAnd: TLabel;
        popupMenuCheckAll: TMenuItem;
        popupMenuUncheckAll: TMenuItem;
        popupMenuCheckSelected: TMenuItem;
        panelCount: TPanel;
        panelButtons: TPanel;
        panelSetPerm: TPanel;
        panelSelectExecute: TPanel;
        panelOutput: TPanel;
        panelPermSelectAnd: TPanel;
        panelSelectAnd: TPanel;
        panelPermSelect: TPanel;
        panelCommand: TPanel;
        panelFolder: TPanel;
        popupMenuSelect: TPopupMenu;
        radioBfs: TRadioButton;
        radioAllTypes: TRadioButton;
        radioDirsOnly: TRadioButton;
        radioFilesOnly: TRadioButton;
        radioSelectAny: TRadioButton;
        radioSelectAnyAnd: TRadioButton;
        radioSelectAtLeast: TRadioButton;
        radioSelectAtLeastAnd: TRadioButton;
        radioSelectExactly: TRadioButton;
        radioFind: TRadioButton;
        radioSelectExactlyAnd: TRadioButton;
        speedButtonClearExclude: TSpeedButton;
        stringGridOutput: TStringGrid;
        ueledBusy: TuELED;
        uniqueInstance: TUniqueInstance;
        procedure buttonAboutClick(Sender: TObject);
        procedure buttonExitClick(Sender: TObject);
        procedure buttonHelpClick(Sender: TObject);
        procedure buttonSelectExecuteClick(Sender: TObject);
        procedure buttonSetPermissionsClick(Sender: TObject);
        procedure checkSelectAllChange(Sender: TObject);
        procedure checkSelectAndChange(Sender: TObject);
        procedure directoryFindChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure popupMenuCheckAllClick(Sender: TObject);
        procedure popupMenuCheckSelectedClick(Sender: TObject);
        procedure popupMenuUncheckAllClick(Sender: TObject);
        procedure speedButtonClearExcludeClick(Sender: TObject);
    private

    public

    end;

var
    formMain: TformMain;

implementation

{$R *.lfm}

{ TformMain }

type
    MyStringArray = array of string;

var
    find_path: string;
    bfs_path: string;
    chmod_path: string;

const
    CONFIG_FILE = '~/.config/PermAudit/settings.ini';

procedure AddParameter(var parameters: MyStringArray; Value: string);
begin
    SetLength(parameters, Length(parameters) + 1);
    parameters[Length(parameters) - 1] := Value;
end;

function BuildPerm1(): string;
var
    perm_temp: integer;
    tmp: string;
begin
    perm_temp := 0;
    if formMain.checkSelectOwnerSuid.Checked then
    begin
        perm_temp := perm_temp + 4000;
    end;
    if formMain.checkSelectGroupGuid.Checked then
    begin
        perm_temp := perm_temp + 2000;
    end;
    if formMain.checkSelectOtherSticky.Checked then
    begin
        perm_temp := perm_temp + 1000;
    end;
    if formMain.checkSelectOwnerRead.Checked then
    begin
        perm_temp := perm_temp + 400;
    end;
    if formMain.checkSelectOwnerWrite.Checked then
    begin
        perm_temp := perm_temp + 200;
    end;
    if formMain.checkSelectOwnerExec.Checked then
    begin
        perm_temp := perm_temp + 100;
    end;
    if formMain.checkSelectGroupRead.Checked then
    begin
        perm_temp := perm_temp + 40;
    end;
    if formMain.checkSelectGroupWrite.Checked then
    begin
        perm_temp := perm_temp + 20;
    end;
    if formMain.checkSelectGroupExec.Checked then
    begin
        perm_temp := perm_temp + 10;
    end;
    if formMain.checkSelectOtherRead.Checked then
    begin
        perm_temp := perm_temp + 4;
    end;
    if formMain.checkSelectOtherWrite.Checked then
    begin
        perm_temp := perm_temp + 2;
    end;
    if formMain.checkSelectOtherExec.Checked then
    begin
        perm_temp := perm_temp + 1;
    end;
    tmp := IntToStr(perm_temp);
    while Length(tmp) < 3 do
    begin
        tmp := '0' + tmp;
    end;
    Result := tmp;
end;

function BuildPerm2(): string;
var
    perm_temp: integer;
    tmp: string;
begin
    perm_temp := 0;
    if formMain.checkSelectOwnerSuidAnd.Checked then
    begin
        perm_temp := perm_temp + 4000;
    end;
    if formMain.checkSelectGroupGuidAnd.Checked then
    begin
        perm_temp := perm_temp + 2000;
    end;
    if formMain.checkSelectOtherStickyAnd.Checked then
    begin
        perm_temp := perm_temp + 1000;
    end;
    if formMain.checkSelectOwnerReadAnd.Checked then
    begin
        perm_temp := perm_temp + 400;
    end;
    if formMain.checkSelectOwnerWriteAnd.Checked then
    begin
        perm_temp := perm_temp + 200;
    end;
    if formMain.checkSelectOwnerExecAnd.Checked then
    begin
        perm_temp := perm_temp + 100;
    end;
    if formMain.checkSelectGroupReadAnd.Checked then
    begin
        perm_temp := perm_temp + 40;
    end;
    if formMain.checkSelectGroupWriteAnd.Checked then
    begin
        perm_temp := perm_temp + 20;
    end;
    if formMain.checkSelectGroupExecAnd.Checked then
    begin
        perm_temp := perm_temp + 10;
    end;
    if formMain.checkSelectOtherReadAnd.Checked then
    begin
        perm_temp := perm_temp + 4;
    end;
    if formMain.checkSelectOtherWriteAnd.Checked then
    begin
        perm_temp := perm_temp + 2;
    end;
    if formMain.checkSelectOtherExecAnd.Checked then
    begin
        perm_temp := perm_temp + 1;
    end;
    tmp := IntToStr(perm_temp);
    while Length(tmp) < 3 do
    begin
        tmp := '0' + tmp;
    end;
    Result := tmp;
end;

function BuildPermSet(): string;
var
    perm_temp: integer;
    tmp: string;
begin
    perm_temp := 0;
    if formMain.checkSetPermOwnerSuid.Checked then
    begin
        perm_temp := perm_temp + 4000;
    end;
    if formMain.checkSetPermGroupGuid.Checked then
    begin
        perm_temp := perm_temp + 2000;
    end;
    if formMain.checkSetPermOtherSticky.Checked then
    begin
        perm_temp := perm_temp + 1000;
    end;
    if formMain.checkSetPermOwnerRead.Checked then
    begin
        perm_temp := perm_temp + 400;
    end;
    if formMain.checkSetPermOwnerWrite.Checked then
    begin
        perm_temp := perm_temp + 200;
    end;
    if formMain.checkSetPermOwnerExec.Checked then
    begin
        perm_temp := perm_temp + 100;
    end;
    if formMain.checkSetPermGroupRead.Checked then
    begin
        perm_temp := perm_temp + 40;
    end;
    if formMain.checkSetPermGroupWrite.Checked then
    begin
        perm_temp := perm_temp + 20;
    end;
    if formMain.checkSetPermGroupExec.Checked then
    begin
        perm_temp := perm_temp + 10;
    end;
    if formMain.checkSetPermOtherRead.Checked then
    begin
        perm_temp := perm_temp + 4;
    end;
    if formMain.checkSetPermOtherWrite.Checked then
    begin
        perm_temp := perm_temp + 2;
    end;
    if formMain.checkSetPermOtherExec.Checked then
    begin
        perm_temp := perm_temp + 1;
    end;
    tmp := IntToStr(perm_temp);
    while Length(tmp) < 3 do
    begin
        tmp := '0' + tmp;
    end;
    Result := tmp;
end;

procedure CheckUncheckAll(status: boolean);
var
    chk: string;
    k: integer;
begin
    if formMain.stringGridOutput.RowCount <= 1 then
        exit;
    if status then
        chk := formMain.stringGridOutput.Columns[0].ValueChecked
    else
        chk := formMain.stringGridOutput.Columns[0].ValueUnchecked;
    for k := 1 to (formMain.stringGridOutput.RowCount - 1) do
    begin
        formMain.stringGridOutput.Cells[0, k] := chk;
    end;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
    // Set the ".ini" file path for properties storage
    IniPropStorage.IniFileName := ExpandFileName(CONFIG_FILE);
end;

procedure TformMain.FormShow(Sender: TObject);
var
    path: string;
begin
    // Get environment "PATH"
    path := GetEnvironmentVariable('PATH');
    // Look for commands
    bfs_path := FileSearch('bfs', path);
    find_path := FileSearch('find', path);
    chmod_path := FileSearch('chmod', path);
    // Check if "bfs" command exists
    if bfs_path <> '' then
    begin
        radioBfs.Enabled := True;
    end
    else
    begin
        radioBfs.Enabled := False;
    end;
    // Check if "find" command exists
    if find_path <> '' then
    begin
        radioFind.Enabled := True;
    end
    else
    begin
        radioFind.Enabled := False;
    end;
    // Manage the results
    if ((radioBfs.Enabled = False) and (radioFind.Enabled = False)) then
    begin
        // If both commands not exists exit with a message
        MessageDlg('Commands "bfs" and "find" not found!', mtError, [mbClose], 0);
        formMain.Close;
    end
    else if ((radioBfs.Enabled = False) and (radioFind.Enabled = True)) then
    begin
        // Force "find"
        radioFind.Checked := True;
    end
    else if ((radioBfs.Enabled = True) and (radioFind.Enabled = False)) then
    begin
        // Force "bfs"
        radioBfs.Checked := True;
    end;
end;

procedure TformMain.popupMenuCheckAllClick(Sender: TObject);
begin
    if checkSelectAll.Checked then
        CheckUncheckAll(True)
    else
        checkSelectAll.Checked := True;
end;

procedure TformMain.popupMenuCheckSelectedClick(Sender: TObject);
var
    valNo: string;
    valYes: string;
    k: integer;
begin
    valYes := stringGridOutput.Columns[0].ValueChecked;
    valNo := stringGridOutput.Columns[0].ValueUnchecked;
    // Check every item that is selected
    for k := 1 to (stringGridOutput.RowCount - 1) do
    begin
        if stringGridOutput.IsCellSelected[0, k] then
            stringGridOutput.Cells[0, k] := valYes
        else
            stringGridOutput.Cells[0, k] := valNo;
    end;
end;

procedure TformMain.popupMenuUncheckAllClick(Sender: TObject);
begin
    if not checkSelectAll.Checked then
        CheckUncheckAll(False)
    else
        checkSelectAll.Checked := False;
end;

procedure TformMain.speedButtonClearExcludeClick(Sender: TObject);
begin
    editExclude.Text := '';
end;

procedure TformMain.buttonExitClick(Sender: TObject);
begin
    // Exit from program
    formMain.Close;
end;

procedure TformMain.buttonHelpClick(Sender: TObject);
begin
    formHelp.ShowModal;
end;

procedure TformMain.buttonAboutClick(Sender: TObject);
begin
    formAbout.ShowModal;
end;

procedure TformMain.buttonSelectExecuteClick(Sender: TObject);
var
    current_dir: string;
    command: string;
    parameters: MyStringArray = nil;
    permissions: string;
    string_out: ansistring;
    res: boolean;
    string_list_out: TStringDynArray;
    pos: longint;
    fil: string;
    perm: string;
    k: integer;
begin
    // Prepare GUI for elaboration
    buttonSelectExecute.Enabled := False;
    ueledBusy.Color := clRed;
    Screen.Cursor := crHourGlass;
    panelOutput.Enabled := False;
    stringGridOutput.Enabled := False;
    stringGridOutput.Clean;
    stringGridOutput.RowCount := stringGridOutput.FixedRows;
    labelCount.Caption := '';
    stringGridOutput.Enabled := False;
    panelSetPerm.Enabled := False;
    checkSelectAll.Checked := False;
    Application.ProcessMessages;
    // Select the command
    if radioBfs.Checked then
    begin
        command := bfs_path;
    end
    else
    begin
        command := find_path;
    end;
    // Set the directory
    current_dir := directoryFind.Text;
    // Set then parameters
    AddParameter(parameters, current_dir);
    // Is there anything to be excluded?
    if editExclude.Text <> '' then
    begin
        AddParameter(parameters, '-path');
        AddParameter(parameters, ConcatPaths([current_dir, editExclude.Text]));
        AddParameter(parameters, '-prune');
        AddParameter(parameters, '-o');
    end;
    // If "bfs" disable colors
    if radioBfs.Checked then
    begin
        AddParameter(parameters, '-nocolor');
    end;
    // Which type needs to be found
    if radioFilesOnly.Checked then
    begin
        AddParameter(parameters, '-type');
        AddParameter(parameters, 'f');
    end
    else if radioDirsOnly.Checked then
    begin
        AddParameter(parameters, '-type');
        AddParameter(parameters, 'd');
    end;
    // Which type of search?
    if checkSelectNot.Checked then
    begin
        AddParameter(parameters, '-not');
    end;
    AddParameter(parameters, '-perm');
    permissions := '';
    if radioSelectAtLeast.Checked then
    begin
        permissions := '-';
    end;
    if radioSelectAny.Checked then
    begin
        permissions := '/';
    end;
    // Get selected permissions
    permissions := permissions + BuildPerm1();
    AddParameter(parameters, permissions);
    if checkSelectAnd.Checked then
    begin
        // Which type of search?
        if checkSelectNotAnd.Checked then
        begin
            AddParameter(parameters, '-not');
        end;
        AddParameter(parameters, '-perm');
        permissions := '';
        if radioSelectAtLeastAnd.Checked then
        begin
            permissions := '-';
        end;
        if radioSelectAnyAnd.Checked then
        begin
            permissions := '/';
        end;
        // Get selected permissions
        permissions := permissions + BuildPerm2();
        AddParameter(parameters, permissions);
    end;
    // Add parameters for output
    AddParameter(parameters, '-printf');
    AddParameter(parameters, '%P\t%M\n');
    // Execute the command
    res := RunCommandIndir(current_dir, command, parameters, string_out);
    // Check for errors
    if res <> True then
    begin
        MessageDlg('Error while executing the search!', mtError, [mbOK], 0);
    end
    else if Length(string_out) > 0 then
    begin
        // Load CheckList with results
        string_list_out := string_out.Split(#10);
        // If empty delete last item
        if string_list_out[High(string_list_out)] = '' then
        begin
            Delete(string_list_out, High(string_list_out), 1);
        end;
        for k := Low(string_list_out) to High(string_list_out) do
        begin
            pos := RPos(#9, string_list_out[k]);
            fil := string_list_out[k].Substring(0, pos - 1);
            perm := string_list_out[k].Substring(pos);
            stringGridOutput.InsertRowWithValues(stringGridOutput.RowCount,
                ['0', fil, perm]);
        end;
    end;
    // Return GUI to active status
    if stringGridOutput.RowCount > 1 then
    begin
        stringGridOutput.Enabled := True;
        panelOutput.Enabled := True;
        panelSetPerm.Enabled := True;
        labelCount.Caption := IntToStr(stringGridOutput.RowCount - 1);
    end;
    Screen.Cursor := crDefault;
    ueledBusy.Color := clLime;
    buttonSelectExecute.Enabled := True;
end;

procedure TformMain.buttonSetPermissionsClick(Sender: TObject);
var
    parameters: array[0..1] of ansistring;
    current_dir: string;
    k: integer;
    res: integer;
    chk: string;
    err: integer;
    done: integer;
begin
    // Test if 'chmod' is available
    if chmod_path = '' then
    begin
        MessageDlg('Command "chmod" not found!', mtError, [mbOK], 0);
        Exit;
    end;
    // Prepare GUI for elaboration
    buttonSetPermissions.Enabled := False;
    ueledBusy.Color := clRed;
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    // Set the permissions
    err := 0;
    done := 0;
    current_dir := directoryFind.Text;
    parameters[0] := BuildPermSet();
    chk := stringGridOutput.Columns[0].ValueChecked;
    // Test the whole list
    for k := 1 to (stringGridOutput.RowCount - 1) do
    begin
        if stringGridOutput.Cells[0, k] = chk then
        begin
            parameters[1] := IncludeTrailingPathDelimiter(current_dir) +
                stringGridOutput.Cells[1, k];
            res := ExecuteProcess(chmod_path, parameters);
            if res = 0 then
                done := done + 1
            else
                err := err + 1;
        end;
    end;
    if done > 0 then
        MessageDlg('Modified files: ' + IntToStr(done), mtInformation, [mbOK], 0)
    else
        MessageDlg('No files checked!', mtWarning, [mbOK], 0);
    if err > 0 then
        MessageDlg('Files not modified: ' + IntToStr(err), mtError, [mbOK], 0);
    // Return GUI to active status
    Screen.Cursor := crDefault;
    ueledBusy.Color := clLime;
    buttonSetPermissions.Enabled := True;
end;

procedure TformMain.checkSelectAllChange(Sender: TObject);
begin
    CheckUncheckAll(checkSelectAll.Checked);
end;

procedure TformMain.checkSelectAndChange(Sender: TObject);
begin
    // Enable or disable "and" selection
    if checkSelectAnd.Checked then
    begin
        panelPermSelectAnd.Enabled := True;
    end
    else
    begin
        panelPermSelectAnd.Enabled := False;
    end;
end;

procedure TformMain.directoryFindChange(Sender: TObject);
begin
    editExclude.Text := '';
end;

end.
