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

unit unit_form_about;

{$mode ObjFPC}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, GifAnim,
    LResources, StdCtrls, Buttons, unit_form_license;

type

    { TformAbout }

    TformAbout = class(TForm)
        BitBtnLicense: TBitBtn;
        BitBtnOk: TBitBtn;
        GifAnim: TGifAnim;
        PanelGif: TPanel;
        StaticText1: TStaticText;
        StaticTextCopyright: TStaticText;
        StaticTextDate: TStaticText;
        StaticTextVersion: TStaticText;
        procedure BitBtnLicenseClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private

    public

    end;

var
    formAbout: TformAbout;

implementation

{$R *.lfm}

{ TformAbout }

procedure TformAbout.FormCreate(Sender: TObject);
begin
    GifAnim.LoadFromLazarusResource('dersoft_2024_logo');
end;

// Show program license
procedure TformAbout.BitBtnLicenseClick(Sender: TObject);
begin
    formLicense.ShowModal;
end;

initialization
    {$I logo-gif.lrs}

end.
