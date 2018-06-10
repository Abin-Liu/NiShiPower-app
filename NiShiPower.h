// NiShiPower.h : main header file for the NISHIPOWER application
//

#if !defined(AFX_NISHIPOWER_H__A9B5E4EE_FCB4_413C_A170_B61B2843EC27__INCLUDED_)
#define AFX_NISHIPOWER_H__A9B5E4EE_FCB4_413C_A170_B61B2843EC27__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols
#include "Includes\WinAppEx.h"

/////////////////////////////////////////////////////////////////////////////
// CNiShiPowerApp:
// See NiShiPower.cpp for the implementation of this class
//

class CNiShiPowerApp : public CWinAppEx
{
public:
	CNiShiPowerApp();
	void InstallAddOn();
	void UninstallAddOn();
	CString m_sAddOnPath;

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CNiShiPowerApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

public:
	//{{AFX_MSG(CNiShiPowerApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_NISHIPOWER_H__A9B5E4EE_FCB4_413C_A170_B61B2843EC27__INCLUDED_)