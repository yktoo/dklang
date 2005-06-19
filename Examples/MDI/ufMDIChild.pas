//**********************************************************************************************************************
//  $Id: ufMDIChild.pas,v 1.2 2005-06-19 12:31:38 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Localization Package
//  Copyright (c)DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
// This is a child MDI form. Attention: read the comments in Main.pas! 
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
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}

  procedure TfMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
     // Set Action to caFree to destroy the form on close
    Action := caFree;
  end;

  procedure TfMDIChild.FormCreate(Sender: TObject);
  begin
    Caption := Name;
  end;

end.
