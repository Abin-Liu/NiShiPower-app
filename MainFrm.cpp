// MainFrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include "NiShiPower.h"
#include "MainFrm.h"
#include "ConfigDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
		// No message handlers
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD, GetDesktopWindow())
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// CMainFrame

IMPLEMENT_DYNAMIC(CMainFrame, CWoWMainFrame)

BEGIN_MESSAGE_MAP(CMainFrame, CWoWMainFrame)
	//{{AFX_MSG_MAP(CMainFrame)
	ON_COMMAND(ID_POPUP_ABOUT, OnAppAbout)
	ON_UPDATE_COMMAND_UI(ID_POPUP_AUTOCLOSE, OnUpdateScheduleShutdown)
	ON_COMMAND(ID_POPUP_AUTOCLOSE, OnScheduleShutdown)
	ON_COMMAND(ID_POPUP_CONFIG, OnConfig)
	ON_COMMAND(ID_APP_HELP, OnAppHelp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMainFrame construction/destruction

CMainFrame::CMainFrame()
{
	// TODO: add member initialization code here	
	SetTitleIcon(APP_TITLE, IDI_TRAY);
	SetHelpFile(AfxGetAppEx()->GetAppDir() + _T("\\NiShiPower.chm"));
	SetThread(&m_thread, FALSE);
}

CMainFrame::~CMainFrame()
{	
}

BOOL CMainFrame::PreStart()
{
	if (m_thread.AreKeysValid())
		return TRUE;

	MessageBox("你必须先正确设置各个按键才能启动程序。");
	return FALSE;
}

void CMainFrame::OnAppAbout()
{
	CAboutDlg dlg;
	DoModal(&dlg);
}

void CMainFrame::OnConfig() 
{
	// TODO: Add your command handler code here
	m_thread.Stop();
	LPNISHIKEYS pKeys = m_thread.GetKeys();
		
	CConfigDlg dlg(pKeys->dwMainKey, pKeys->dwMoveKey, pKeys->dwInteractKey);
	if (DoModal(&dlg))
	{		
		pKeys->dwMainKey = dlg.m_dwMainKey;
		pKeys->dwMoveKey = dlg.m_dwMoveKey;
		pKeys->dwInteractKey = dlg.m_dwInteractKey;
	}	
}
