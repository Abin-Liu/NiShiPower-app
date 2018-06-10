// ConfigDlg.cpp : implementation file
//

#include "stdafx.h"
#include "NiShiPower.h"
#include "ConfigDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CConfigDlg dialog


CConfigDlg::CConfigDlg(DWORD dwMainKey, DWORD dwMoveKey, DWORD dwInteractKey)
	: CDialog(CConfigDlg::IDD, GetDesktopWindow())
{
	//{{AFX_DATA_INIT(CConfigDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	m_dwMainKey = dwMainKey;
	m_dwMoveKey = dwMoveKey;
	m_dwInteractKey = dwInteractKey;
}


void CConfigDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CConfigDlg)
	DDX_Control(pDX, IDC_MOVE, m_wndMove);
	DDX_Control(pDX, IDC_MAIN, m_wndMain);
	DDX_Control(pDX, IDC_INTERACT, m_wndInteract);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CConfigDlg, CDialog)
	//{{AFX_MSG_MAP(CConfigDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CConfigDlg message handlers

BOOL CConfigDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	m_wndMain.SetHotKey(m_dwMainKey);
	m_wndMove.SetHotKey(m_dwMoveKey);
	m_wndInteract.SetHotKey(m_dwInteractKey);
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

void CConfigDlg::OnOK() 
{
	// TODO: Add extra validation here
	m_dwMainKey = m_wndMain.GetHotKey();
	m_dwMoveKey = m_wndMove.GetHotKey();
	m_dwInteractKey = m_wndInteract.GetHotKey();
	CDialog::OnOK();
}
