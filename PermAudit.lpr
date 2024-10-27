{-------------------------------------------------------------------------------

FindPerm : a simple GUI to use bfs/find command for search by permissions
Copyright (C)derSoft 2024

                        ---------- 000 ----------

This file is part of FindPerm.

FindPerm is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.

FindPerm is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
FindPerm. If not, see <https://www.gnu.org/licenses/>.

-------------------------------------------------------------------------------}

program PermAudit;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}
    cthreads,
    {$ENDIF}
    {$IFDEF HASAMIGA}
    athreads,
    {$ENDIF}
    Interfaces, // this includes the LCL widgetset
    Forms,
    uecontrols,
    poweredby,
    pkg_gifanim, FrameViewer09,
    UnitFormMain,
    unit_form_about,
    unit_form_license,
    unit_form_help { you can add units after this };

    {$R *.res}

begin
    RequireDerivedFormResource := True;
	Application.Scaled:=True;
    Application.Initialize;
    Application.CreateForm(TformMain, formMain);
    Application.CreateForm(TformAbout, formAbout);
    Application.CreateForm(TformLicense, formLicense);
	Application.CreateForm(TformHelp, formHelp);
    Application.Run;
end.
