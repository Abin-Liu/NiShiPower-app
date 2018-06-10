// MainFrm.h : interface of the CMainFrame class
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_MAINFRM_H__8F70C65B_C727_4FC8_9097_81E97CFBA923__INCLUDED_)
#define AFX_MAINFRM_H__8F70C65B_C727_4FC8_9097_81E97CFBA923__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Includes\WoWMainFrame.h"
#include "NiShiPowerThread.h"

class CMainFrame : public CWoWMainFrame
{
	
public:
	CMainFrame();
protected: 
	DECLARE_DYNAMIC(CMainFrame)

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMainFrame)
	public:
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CMainFrame();

// Generated message map functions
protected:
	//{{AFX_MSG(CMainFrame)
	afx_msg void OnConfig();
	afx_msg void OnAppAbout();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

protected:

	BOOL PreStart();
	CNiShiPowerThread m_thread;
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MAINFRM_H__8F70C65B_C727_4FC8_9097_81E97CFBA923__INCLUDED_)
