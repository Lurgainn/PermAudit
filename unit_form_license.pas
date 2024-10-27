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

unit unit_form_license;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
    StdCtrls;

type

    { TformLicense }

    TformLicense = class(TForm)
        bitbtnOk: TBitBtn;
        memoLicense: TMemo;
        panelLicense: TPanel;
    private

    public

    end;

var
    formLicense: TformLicense;

implementation

{$R *.lfm}

end.
