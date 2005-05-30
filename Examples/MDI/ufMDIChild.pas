//**********************************************************************************************************************
//  $Id: ufMDIChild.pas,v 1.1 2005-05-30 12:46:20 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit ufMDIChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DKLang, StdCtrls;

type
  TfMDIChild = class(TForm)
    bCancel: TButton;
    lcMain: TDKLanguageController;
    lSampleMessage: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}

  procedure TfMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
     // Set this to caFree to destroy the form on close
    Action := caFree;
  end;

end.
