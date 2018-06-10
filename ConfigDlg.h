#if !defined(AFX_CONFIGDLG_H__C1CA9786_90A1_4F80_A386_8005B3C223B8__INCLUDED_)
#define AFX_CONFIGDLG_H__C1CA9786_90A1_4F80_A386_8005B3C223B8__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ConfigDlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CConfigDlg dialog

#include "Includes\HotKeyCtrlEx.h"

class CConfigDlg : public CDialog
{
// Construction
public:
	CConfigDlg(DWORD dwMainKey, DWORD dwMoveKey, DWORD dwInteractKey);   // standard constructor
	DWORD m_dwMainKey;
	DWORD m_dwMoveKey;
	DWORD m_dwInteractKey;

// Dialog Data
	//{{AFX_DATA(CConfigDlg)
	enum { IDD = IDD_CONFIGDLG };
	CHotKeyCtrlEx	m_wndMove;
	CHotKeyCtrlEx	m_wndMain;
	CHotKeyCtrlEx	m_wndInteract;
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CConfigDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CConfigDlg)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CONFIGDLG_H__C1CA9786_90A1_4F80_A386_8005B3C223B8__INCLUDED_)
