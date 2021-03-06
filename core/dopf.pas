(*
  Duall Sistemas, Object Persistence Classes

  Copyright (C) 2014 Silvio Clecio

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit dOPF;

{$i dopf.inc}

interface

uses
  dClasses, dUtils, Classes, SysUtils, DB;

type
  EdNotImplemented = class(EdException);

  EdConnection = class(EdException);

  EdQuery = class(EdException);

  TdLogType = (ltTransaction, ltSQL, ltCustom);

  TdLogFilter = set of TdLogType;

  TdLogEvent = procedure(const AType: TdLogType; const AMsg: string) of object;

  { TdLogger }

  TdLogger = class(TdObject)
  private
    FActive: Boolean;
    FFileName: TFileName;
    FFilter: TdLogFilter;
    FOnLog: TdLogEvent;
    FStream: TFileStream;
    procedure SetActive(AValue: Boolean);
    procedure SetFileName(AValue: TFileName);
  protected
    property Stream: TFileStream read FStream write FStream;
  public
    constructor Create(const AFileName: TFileName); overload; virtual;
    destructor Destroy; override;
    procedure Log(const AType: TdLogType; AMsg: string);
    property Active: Boolean read FActive write SetActive;
    property Filter: TdLogFilter read FFilter write FFilter;
    property FileName: TFileName read FFileName write SetFileName;
    property OnLog: TdLogEvent read FOnLog write FOnLog;
  end;

  { TdConnectionBroker }

  TdConnectionBroker = class(TdObject)
  protected
    function GetConnection: TObject; virtual;
    function GetTransaction: TObject; virtual;
    function GetConnected: Boolean; virtual;
    function GetDatabase: string; virtual;
    function GetDriver: string; virtual;
    function GetHost: string; virtual;
    function GetPassword: string; virtual;
    function GetPort: Integer; virtual;
    function GetUser: string; virtual;
    procedure SetConnected({%H-}const AValue: Boolean); virtual;
    procedure SetDatabase({%H-}const AValue: string); virtual;
    procedure SetDriver({%H-}const AValue: string); virtual;
    procedure SetHost({%H-}const AValue: string); virtual;
    procedure SetPassword({%H-}const AValue: string); virtual;
    procedure SetPort({%H-}const AValue: Integer); virtual;
    procedure SetUser({%H-}const AValue: string); virtual;
  public
    constructor Create; virtual;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    procedure StartTransaction; virtual;
    procedure Commit; virtual;
    procedure CommitRetaining; virtual;
    procedure Rollback; virtual;
    procedure RollbackRetaining; virtual;
    function InTransaction: Boolean; virtual;
    property Connection: TObject read GetConnection;
    property Transaction: TObject read GetTransaction;
    property Connected: Boolean read GetConnected write SetConnected;
  published
    property Driver: string read GetDriver write SetDriver;
    property Database: string read GetDatabase write SetDatabase;
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
    property Host: string read GetHost write SetHost;
    property Port: Integer read GetPort write SetPort;
  end;

  { TdGConnection }

  generic TdGConnection<T1, T2> = class(TdComponent)
  private
    FBroker: T1;
    FLogger: T2;
    function GetConnected: Boolean;
    function GetDatabase: string;
    function GetDriver: string;
    function GetHost: string;
    function GetPassword: string;
    function GetPort: Integer;
    function GetUser: string;
    procedure SetConnected(const AValue: Boolean);
    procedure SetDatabase(const AValue: string);
    procedure SetDriver(const AValue: string);
    procedure SetHost(const AValue: string);
    procedure SetPassword(const AValue: string);
    procedure SetPort(const AValue: Integer);
    procedure SetUser(const AValue: string);
  protected
    procedure CheckBrokerClass; virtual;
    procedure CheckBroker; virtual;
    procedure CheckLoggerClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure StartTransaction;
    procedure Commit;
    procedure CommitRetaining;
    procedure Rollback;
    procedure RollbackRetaining;
    function InTransaction: Boolean;
    property Broker: T1 read FBroker write FBroker;
    property Logger: T2 read FLogger write FLogger;
    property Connected: Boolean read GetConnected write SetConnected;
  published
    property Driver: string read GetDriver write SetDriver;
    property Database: string read GetDatabase write SetDatabase;
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
    property Host: string read GetHost write SetHost;
    property Port: Integer read GetPort write SetPort;
  end;

  { TdQueryBroker }

  TdQueryBroker = class(TdObject)
  protected
    function GetActive: Boolean; virtual;
    function GetBOF: Boolean; virtual;
    function GetConnection: TObject; virtual;
    function GetDataSet: TDataSet; virtual;
    function GetDataSource: TDataSource; virtual;
    function GetEOF: Boolean; virtual;
    function GetFieldDefs: TFieldDefs; virtual;
    function GetFields: TFields; virtual;
    function GetModified: Boolean; virtual;
    function GetParams: TParams; virtual;
    function GetPosition: Int64; virtual;
    function GetSQL: TStrings; virtual;
    function GetState: TDataSetState; virtual;
    procedure SetActive({%H-}const AValue: Boolean); virtual;
    procedure SetConnection({%H-}AValue: TObject); virtual;
    procedure SetDataSource({%H-}AValue: TDataSource); virtual;
    procedure SetPosition({%H-}const AValue: Int64); virtual;
  public
    constructor Create; virtual;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    procedure Apply; virtual;
    procedure ApplyRetaining; virtual;
    procedure Undo; virtual;
    procedure UndoRetaining; virtual;
    procedure Append; virtual;
    procedure Insert; virtual;
    procedure Edit; virtual;
    procedure Cancel; virtual;
    procedure Delete; virtual;
    procedure Open; virtual;
    procedure Close; virtual;
    procedure Refresh; virtual;
    procedure First; virtual;
    procedure Prior; virtual;
    procedure Next; virtual;
    procedure Last; virtual;
    procedure Post; virtual;
    procedure Execute; virtual;
    function RowsAffected: Int64; virtual;
    function Locate({%H-}const AKeyFields: string;{%H-}const AKeyValues: Variant;
      {%H-}const AOptions: TLocateOptions = []): Boolean; virtual;
    function Param({%H-}const AName: string): TParam; virtual;
    function Field({%H-}const AName: string): TField; virtual;
    function FieldDef({%H-}const AName: string): TFieldDef; virtual;
    function Count: Int64; virtual;
    function GetBookmark: TBookmark; virtual;
    procedure GotoBookmark({%H-}ABookmark: TBookmark); virtual;
    property BOF: Boolean read GetBOF;
    property EOF: Boolean read GetEOF;
    property Bookmark: TBookmark read GetBookmark write GotoBookmark;
    property Modified: Boolean read GetModified;
    property Position: Int64 read GetPosition write SetPosition;
  published
    property Active: Boolean read GetActive write SetActive;
    property SQL: TStrings read GetSQL;
    property Fields: TFields read GetFields;
    property Params: TParams read GetParams;
    property State: TDataSetState read GetState;
    property DataSet: TDataSet read GetDataSet;
    property FieldDefs: TFieldDefs read GetFieldDefs;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Connection: TObject read GetConnection write SetConnection;
  end;

  { TdGQuery }

  generic TdGQuery<T1, T2> = class(TdComponent)
  private
    FBroker: T1;
    FConnection: T2;
    function GetActive: Boolean;
    function GetBOF: Boolean;
    function GetDataSet: TDataSet;
    function GetDataSource: TDataSource;
    function GetEOF: Boolean;
    function GetFieldDefs: TFieldDefs;
    function GetFields: TFields;
    function GetModified: Boolean;
    function GetParams: TParams;
    function GetPosition: Int64;
    function GetSQL: TStrings;
    function GetState: TDataSetState;
    procedure SetActive(const AValue: Boolean);
    procedure SetDataSource(AValue: TDataSource);
    procedure SetPosition(const AValue: Int64);
  protected
    procedure CheckConnection; virtual;
    procedure CheckBrokerClass; virtual;
    procedure CheckBroker; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyUpdates;
    procedure CancelUpdates;
    procedure Apply;
    procedure ApplyRetaining;
    procedure Undo;
    procedure UndoRetaining;
    procedure Append;
    procedure Insert;
    procedure Edit;
    procedure Cancel;
    procedure Delete;
    procedure Open;
    procedure Close;
    procedure Refresh;
    procedure First;
    procedure Prior;
    procedure Next;
    procedure Last;
    procedure Post;
    procedure Execute;
    function RowsAffected: Int64;
    function Locate({%H-}const AKeyFields: string;{%H-}const AKeyValues: Variant;
      {%H-}const AOptions: TLocateOptions = []): Boolean;
    function Param({%H-}const AName: string): TParam;
    function Field({%H-}const AName: string): TField;
    function FieldDef({%H-}const AName: string): TFieldDef;
    function Count: Int64;
    function GetBookmark: TBookmark;
    procedure GotoBookmark({%H-}ABookmark: TBookmark);
    property Connection: T2 read FConnection write FConnection;
    property Broker: T1 read FBroker write FBroker;
    property SQL: TStrings read GetSQL;
    property Fields: TFields read GetFields;
    property FieldDefs: TFieldDefs read GetFieldDefs;
    property Params: TParams read GetParams;
    property BOF: Boolean read GetBOF;
    property EOF: Boolean read GetEOF;
    property Bookmark: TBookmark read GetBookmark write GotoBookmark;
    property Modified: Boolean read GetModified;
    property State: TDataSetState read GetState;
    property Active: Boolean read GetActive write SetActive;
    property DataSet: TDataSet read GetDataSet;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Position: Int64 read GetPosition write SetPosition;
  end;

  { TdGEntityQuery }

  generic TdGEntityQuery<T1, T2, T3> = class(specialize TdGQuery<T1, T2>)
  private
    FEntity: T3;
  protected
    function CreateEntity: T3; virtual;
    procedure FreeEntity; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetFields;
    procedure SetFields;
    procedure GetParams;
    procedure SetParams;
    property Entity: T3 read FEntity write FEntity;
  end;

implementation

procedure NotImplementedError;
begin
  raise EdNotImplemented.Create('Not implemended.');
end;

{ TdLogger }

constructor TdLogger.Create(const AFileName: TFileName);
begin
  inherited Create;
  SetFileName(AFileName);
  FFilter := [ltTransaction, ltSQL, ltCustom];
end;

destructor TdLogger.Destroy;
begin
  FreeAndNil(FStream);
  inherited Destroy;
end;

procedure TdLogger.SetFileName(AValue: TFileName);
var
  F: TFileName;
begin
  if FActive and (Trim(AValue) <> '') and (AValue <> FFileName) then
  begin
    FFileName := AValue;
    FreeAndNil(FStream);
    F := ChangeFileExt(FFileName, '_' + FormatDateTime('yyyymmdd', Date) +
      ExtractFileExt(FFileName));
    if FileExists(F) then
    begin
      FStream := TFileStream.Create(F, fmOpenReadWrite);
      FStream.Seek(FStream.Size, soBeginning);
    end
    else
      FStream := TFileStream.Create(F, fmCreate);
  end;
end;

procedure TdLogger.SetActive(AValue: Boolean);
begin
  if AValue <> FActive then
  begin
    FActive := AValue;
    if not FActive then
      FreeAndNil(FStream);
  end;
end;

procedure TdLogger.Log(const AType: TdLogType; AMsg: string);
var
  T: string;
begin
  if FActive and (AType in FFilter) then
  begin
    WriteStr(T, AType);
    Delete(T, 1, 2);
    AMsg := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' - ' + T +
      ': ' + AMsg;
    if Assigned(FStream) then
    begin
      FStream.Write(AMsg[1], Length(AMsg));
      FStream.Write(LineEnding[1], Length(LineEnding));
    end;
    if Assigned(FOnLog) then
      FOnLog(AType, AMsg);
  end;
end;

{ TdConnectionBroker }

constructor TdConnectionBroker.Create;
begin
  inherited Create;
end;

procedure TdConnectionBroker.Connect;
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.Disconnect;
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.StartTransaction;
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.Commit;
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.CommitRetaining;
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.Rollback;
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.RollbackRetaining;
begin
  NotImplementedError;
end;

function TdConnectionBroker.InTransaction: Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdConnectionBroker.GetConnection: TObject;
begin
  Result := nil;
  NotImplementedError;
end;

function TdConnectionBroker.GetTransaction: TObject;
begin
  Result := nil;
  NotImplementedError;
end;

function TdConnectionBroker.GetConnected: Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdConnectionBroker.GetDatabase: string;
begin
  Result := '';
  NotImplementedError;
end;

function TdConnectionBroker.GetDriver: string;
begin
  Result := '';
  NotImplementedError;
end;

function TdConnectionBroker.GetHost: string;
begin
  Result := '';
  NotImplementedError;
end;

function TdConnectionBroker.GetPassword: string;
begin
  Result := '';
  NotImplementedError;
end;

function TdConnectionBroker.GetPort: Integer;
begin
  Result := 0;
  NotImplementedError;
end;

function TdConnectionBroker.GetUser: string;
begin
  Result := '';
  NotImplementedError;
end;

procedure TdConnectionBroker.SetConnected(const AValue: Boolean);
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.SetDatabase(const AValue: string);
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.SetDriver(const AValue: string);
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.SetHost(const AValue: string);
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.SetPassword(const AValue: string);
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.SetPort(const AValue: Integer);
begin
  NotImplementedError;
end;

procedure TdConnectionBroker.SetUser(const AValue: string);
begin
  NotImplementedError;
end;

{ TdGConnection }

constructor TdGConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CheckBrokerClass;
  CheckLoggerClass;
  FBroker := T1.Create;
  FLogger := T2.Create('');
end;

destructor TdGConnection.Destroy;
begin
  FBroker.Free;
  FLogger.Free;
  inherited Destroy;
end;

procedure TdGConnection.CheckBrokerClass;
begin
  if not T1.InheritsFrom(TdConnectionBroker) then
    raise EdConnection.CreateFmt('Invalid broker class: "%s".', [T1.ClassName]);
end;

procedure TdGConnection.CheckBroker;
begin
  if FBroker = nil then
    raise EdConnection.Create('Broker not assigned.');
end;

procedure TdGConnection.CheckLoggerClass;
begin
  if not T2.InheritsFrom(TdLogger) then
    raise EdConnection.CreateFmt('Invalid logger class: "%s".', [T2.ClassName]);
end;

function TdGConnection.GetConnected: Boolean;
begin
  CheckBroker;
  Result := FBroker.Connected;
end;

function TdGConnection.GetDatabase: string;
begin
  CheckBroker;
  Result := FBroker.Database;
end;

function TdGConnection.GetDriver: string;
begin
  CheckBroker;
  Result := FBroker.Driver;
end;

function TdGConnection.GetHost: string;
begin
  CheckBroker;
  Result := FBroker.Host;
end;

function TdGConnection.GetPassword: string;
begin
  CheckBroker;
  Result := FBroker.Password;
end;

function TdGConnection.GetPort: Integer;
begin
  CheckBroker;
  Result := FBroker.Port;
end;

function TdGConnection.GetUser: string;
begin
  CheckBroker;
  Result := FBroker.User;
end;

procedure TdGConnection.SetConnected(const AValue: Boolean);
begin
  CheckBroker;
  FBroker.Connected := AValue;
end;

procedure TdGConnection.SetDatabase(const AValue: string);
begin
  CheckBroker;
  FBroker.Database := AValue;
end;

procedure TdGConnection.SetDriver(const AValue: string);
begin
  CheckBroker;
  FBroker.Driver := AValue;
end;

procedure TdGConnection.SetHost(const AValue: string);
begin
  CheckBroker;
  FBroker.Host := AValue;
end;

procedure TdGConnection.SetPassword(const AValue: string);
begin
  CheckBroker;
  FBroker.Password := AValue;
end;

procedure TdGConnection.SetPort(const AValue: Integer);
begin
  CheckBroker;
  FBroker.Port := AValue;
end;

procedure TdGConnection.SetUser(const AValue: string);
begin
  CheckBroker;
  FBroker.User := AValue;
end;

procedure TdGConnection.Connect;
begin
  CheckBroker;
  FBroker.Connect;
end;

procedure TdGConnection.Disconnect;
begin
  CheckBroker;
  FBroker.Disconnect;
end;

procedure TdGConnection.StartTransaction;
begin
  CheckBroker;
  FBroker.StartTransaction;
end;

procedure TdGConnection.Commit;
begin
  CheckBroker;
  FLogger.Log(ltTransaction, 'Trying Connection.Commit');
  FBroker.Commit;
end;

procedure TdGConnection.CommitRetaining;
begin
  CheckBroker;
  FLogger.Log(ltTransaction, 'Trying Connection.CommitRetaining');
  FBroker.CommitRetaining;
end;

procedure TdGConnection.Rollback;
begin
  CheckBroker;
  FLogger.Log(ltTransaction, 'Trying Connection.Rollback');
  FBroker.Rollback;
end;

procedure TdGConnection.RollbackRetaining;
begin
  CheckBroker;
  FLogger.Log(ltTransaction, 'Trying Connection.RollbackRetaining');
  FBroker.RollbackRetaining;
end;

function TdGConnection.InTransaction: Boolean;
begin
  CheckBroker;
  Result := FBroker.InTransaction;
end;

{ TdQueryBroker }

constructor TdQueryBroker.Create;
begin
  inherited Create;
end;

procedure TdQueryBroker.ApplyUpdates;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.CancelUpdates;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Apply;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.ApplyRetaining;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Undo;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.UndoRetaining;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Append;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Insert;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Edit;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Cancel;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Delete;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Open;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Close;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Refresh;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.First;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Prior;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Next;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Last;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Post;
begin
  NotImplementedError;
end;

procedure TdQueryBroker.Execute;
begin
  NotImplementedError;
end;

function TdQueryBroker.RowsAffected: Int64;
begin
  Result := 0;
  NotImplementedError;
end;

function TdQueryBroker.Locate(const AKeyFields: string;
  const AKeyValues: Variant; const AOptions: TLocateOptions): Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdQueryBroker.Param(const AName: string): TParam;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.Field(const AName: string): TField;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.FieldDef(const AName: string): TFieldDef;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.Count: Int64;
begin
  Result := 0;
  NotImplementedError;
end;

function TdQueryBroker.GetBookmark: TBookmark;
begin
  Result := nil;
  NotImplementedError;
end;

procedure TdQueryBroker.GotoBookmark(ABookmark: TBookmark);
begin
  NotImplementedError;
end;

function TdQueryBroker.GetConnection: TObject;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetActive: Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdQueryBroker.GetBOF: Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdQueryBroker.GetDataSet: TDataSet;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetDataSource: TDataSource;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetEOF: Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdQueryBroker.GetFieldDefs: TFieldDefs;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetFields: TFields;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetModified: Boolean;
begin
  Result := False;
  NotImplementedError;
end;

function TdQueryBroker.GetParams: TParams;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetPosition: Int64;
begin
  Result := 0;
  NotImplementedError;
end;

function TdQueryBroker.GetSQL: TStrings;
begin
  Result := nil;
  NotImplementedError;
end;

function TdQueryBroker.GetState: TDataSetState;
begin
  Result := dsInactive;
  NotImplementedError;
end;

procedure TdQueryBroker.SetActive(const AValue: Boolean);
begin
  NotImplementedError;
end;

procedure TdQueryBroker.SetConnection(AValue: TObject);
begin
  NotImplementedError;
end;

procedure TdQueryBroker.SetDataSource(AValue: TDataSource);
begin
  NotImplementedError;
end;

procedure TdQueryBroker.SetPosition(const AValue: Int64);
begin
  NotImplementedError;
end;

{ TdGQuery }

constructor TdGQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CheckBrokerClass;
  FBroker := T1.Create;
  FConnection := T2(AOwner);
  if Assigned(AOwner) then
    FBroker.Connection := FConnection.Broker.Connection;
end;

destructor TdGQuery.Destroy;
begin
  FBroker.Free;
  inherited Destroy;
end;

procedure TdGQuery.CheckBrokerClass;
begin
  if not T1.InheritsFrom(TdQueryBroker) then
    raise EdQuery.CreateFmt('Invalid broker class: "%s".', [T1.ClassName]);
end;

procedure TdGQuery.CheckBroker;
begin
  if FBroker = nil then
    raise EdQuery.Create('Broker not assigned.');
end;

procedure TdGQuery.CheckConnection;
begin
  if FConnection = nil then
    raise EdQuery.Create('Connection not assigned.');
end;

function TdGQuery.GetActive: Boolean;
begin
  CheckBroker;
  Result := FBroker.Active;
end;

function TdGQuery.GetBOF: Boolean;
begin
  CheckBroker;
  Result := FBroker.BOF;
end;

function TdGQuery.GetDataSet: TDataSet;
begin
  CheckBroker;
  Result := FBroker.DataSet;
end;

function TdGQuery.GetDataSource: TDataSource;
begin
  CheckBroker;
  Result := FBroker.DataSource;
end;

function TdGQuery.GetEOF: Boolean;
begin
  CheckBroker;
  Result := FBroker.EOF;
end;

function TdGQuery.GetFieldDefs: TFieldDefs;
begin
  CheckBroker;
  Result := FBroker.FieldDefs;
end;

function TdGQuery.GetFields: TFields;
begin
  CheckBroker;
  Result := FBroker.Fields;
end;

function TdGQuery.GetModified: Boolean;
begin
  CheckBroker;
  Result := FBroker.Modified;
end;

function TdGQuery.GetParams: TParams;
begin
  CheckBroker;
  Result := FBroker.Params;
end;

function TdGQuery.GetPosition: Int64;
begin
  CheckBroker;
  Result := FBroker.Position;
end;

function TdGQuery.GetSQL: TStrings;
begin
  CheckBroker;
  Result := FBroker.SQL;
end;

function TdGQuery.GetState: TDataSetState;
begin
  CheckBroker;
  Result := FBroker.State;
end;

procedure TdGQuery.SetActive(const AValue: Boolean);
begin
  CheckBroker;
  FBroker.Active := AValue;
end;

procedure TdGQuery.SetDataSource(AValue: TDataSource);
begin
  CheckBroker;
  FBroker.DataSource := AValue;
end;

procedure TdGQuery.SetPosition(const AValue: Int64);
begin
  CheckBroker;
  FBroker.Position := AValue;
end;

procedure TdGQuery.ApplyUpdates;
begin
  CheckBroker;
  CheckConnection;
  Connection.Logger.Log(ltCustom, 'Trying Query.ApplyUpdates');
  FBroker.ApplyUpdates;
end;

procedure TdGQuery.CancelUpdates;
begin
  CheckBroker;
  CheckConnection;
  Connection.Logger.Log(ltCustom, 'Trying Query.CancelUpdates');
  FBroker.CancelUpdates;
end;

procedure TdGQuery.Apply;
begin
  CheckBroker;
  CheckConnection;
  Connection.Logger.Log(ltCustom, 'Trying Query.Apply');
  FBroker.Apply;
end;

procedure TdGQuery.ApplyRetaining;
begin
  CheckBroker;
  CheckConnection;
  Connection.Logger.Log(ltCustom, 'Trying Query.ApplyRetaining');
  FBroker.ApplyRetaining;
end;

procedure TdGQuery.Undo;
begin
  CheckBroker;
  CheckConnection;
  Connection.Logger.Log(ltCustom, 'Trying Query.Undo');
  FBroker.Undo;
end;

procedure TdGQuery.UndoRetaining;
begin
  CheckBroker;
  CheckConnection;
  Connection.Logger.Log(ltCustom, 'Trying Query.UndoRetaining');
  FBroker.UndoRetaining;
end;

procedure TdGQuery.Append;
begin
  CheckBroker;
  FBroker.Append;
end;

procedure TdGQuery.Insert;
begin
  CheckBroker;
  FBroker.Insert;
end;

procedure TdGQuery.Edit;
begin
  CheckBroker;
  FBroker.Edit;
end;

procedure TdGQuery.Cancel;
begin
  CheckBroker;
  FBroker.Cancel;
end;

procedure TdGQuery.Delete;
begin
  CheckBroker;
  FBroker.Delete;
end;

procedure TdGQuery.Open;
var
  S: string;
begin
  CheckBroker;
  CheckConnection;
  S := Trim(SQL.Text);
  dParameterizeSQL(S, Params);
  Connection.Logger.Log(ltSQL, S);
  FBroker.Open;
end;

procedure TdGQuery.Close;
begin
  CheckBroker;
  FBroker.Close;
end;

procedure TdGQuery.Refresh;
begin
  CheckBroker;
  FBroker.Refresh;
end;

procedure TdGQuery.First;
begin
  CheckBroker;
  FBroker.First;
end;

procedure TdGQuery.Prior;
begin
  CheckBroker;
  FBroker.Prior;
end;

procedure TdGQuery.Next;
begin
  CheckBroker;
  FBroker.Next;
end;

procedure TdGQuery.Last;
begin
  CheckBroker;
  FBroker.Last;
end;

procedure TdGQuery.Post;
begin
  CheckBroker;
  FBroker.Post;
end;

procedure TdGQuery.Execute;
var
  S: string;
begin
  CheckBroker;
  CheckConnection;
  S := Trim(SQL.Text);
  dParameterizeSQL(S, Params);
  Connection.Logger.Log(ltSQL, S);
  FBroker.Execute;
end;

function TdGQuery.RowsAffected: Int64;
begin
  CheckBroker;
  Result := FBroker.RowsAffected;
end;

function TdGQuery.Locate(const AKeyFields: string; const AKeyValues: Variant;
  const AOptions: TLocateOptions): Boolean;
begin
  CheckBroker;
  Result := FBroker.Locate(AKeyFields, AKeyValues, AOptions);
end;

function TdGQuery.Param(const AName: string): TParam;
begin
  CheckBroker;
  Result := FBroker.Param(AName);
end;

function TdGQuery.Field(const AName: string): TField;
begin
  CheckBroker;
  Result := FBroker.Field(AName);
end;

function TdGQuery.FieldDef(const AName: string): TFieldDef;
begin
  CheckBroker;
  Result := FBroker.FieldDef(AName);
end;

function TdGQuery.Count: Int64;
begin
  CheckBroker;
  Result := FBroker.Count;
end;

function TdGQuery.GetBookmark: TBookmark;
begin
  CheckBroker;
  Result := FBroker.Bookmark;
end;

procedure TdGQuery.GotoBookmark(ABookmark: TBookmark);
begin
  CheckBroker;
  FBroker.GotoBookmark(ABookmark);
end;

{ TdGEntityQuery }

constructor TdGEntityQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEntity := CreateEntity;
end;

destructor TdGEntityQuery.Destroy;
begin
  FreeEntity;
  inherited Destroy;
end;

function TdGEntityQuery.CreateEntity: T3;
begin
  Result := T3.Create;
end;

procedure TdGEntityQuery.FreeEntity;
begin
  FreeAndNil(FEntity);
end;

procedure TdGEntityQuery.GetFields;
begin
  Connection.Logger.Log(ltCustom, 'Trying EntityQuery.GetFields');
  dGetFields(FEntity, Fields);
end;

procedure TdGEntityQuery.SetFields;
begin
  Connection.Logger.Log(ltCustom, 'Trying EntityQuery.SetFields');
  dSetFields(FEntity, Fields);
end;

procedure TdGEntityQuery.GetParams;
begin
  Connection.Logger.Log(ltCustom, 'Trying EntityQuery.GetParams');
  dGetParams(FEntity, Params);
end;

procedure TdGEntityQuery.SetParams;
begin
  Connection.Logger.Log(ltCustom, 'Trying EntityQuery.SetParams');
  dSetParams(FEntity, Params);
end;

end.

