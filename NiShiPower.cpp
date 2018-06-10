// NiShiPower.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "NiShiPower.h"
#include "MainFrm.h"
#include "Includes\FileManip.h"
#include "Includes\WoWThread.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CNiShiPowerApp

BEGIN_MESSAGE_MAP(CNiShiPowerApp, CWinApp)
	//{{AFX_MSG_MAP(CNiShiPowerApp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CNiShiPowerApp construction

CNiShiPowerApp::CNiShiPowerApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
	CWoWThread::GetAddOnsPath(m_sAddOnPath.GetBuffer(256), 255);
	m_sAddOnPath.ReleaseBuffer();

	if (!m_sAddOnPath.IsEmpty())
		m_sAddOnPath += _T("\\NiShiPower");
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CNiShiPowerApp object

CNiShiPowerApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CNiShiPowerApp initialization

BOOL CNiShiPowerApp::InitInstance()
{
	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	if (_tcsicmp(m_lpCmdLine, _T("-installaddon")) == 0)
	{
		InstallAddOn();
		return FALSE;
	}

	if (_tcsicmp(m_lpCmdLine, _T("-uninstalladdon")) == 0)
	{
		UninstallAddOn();
		return FALSE;
	}

	SetInstanceUniqueID(_T("{C4322418-C3BA-4B5D-80FD-5DAC0274DE27}"));
	if (!IsInstanceUnique())
		return FALSE;

	SetRegistryKey(_T("Abin"));

	
	CMainFrame* pFrame = new CMainFrame;
	m_pMainWnd = pFrame;

	// create and load the frame with its resources

	pFrame->LoadFrame(IDR_MAINFRAME,
		WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE, NULL,
		NULL);	

	return TRUE;
}

void CNiShiPowerApp::InstallAddOn()
{
	if (m_sAddOnPath.IsEmpty())
	{
		AfxMessageBox(_T("无法找到魔兽世界游戏安装目录。"));
		return;
	}

	if (::GetFileAttributes(m_sAddOnPath) != -1)
		CFileManip::DelTree(m_sAddOnPath);

	CFileManip::XCopy(GetAppDir() + _T("\\UI"), m_sAddOnPath);
}

void CNiShiPowerApp::UninstallAddOn()
{
	if (!m_sAddOnPath.IsEmpty() && ::GetFileAttributes(m_sAddOnPath) != -1)
		CFileManip::DelTree(m_sAddOnPath);
}
