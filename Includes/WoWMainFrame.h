#ifndef __WOWMAINFRAME_H__
#define __WOWMAINFRAME_H__

#include "TrayFrameWnd.h"
#include "WoWThread.h"
#include "Shutdown.h"

class CWoWMainFrame : public CTrayFrameWnd
{	
public:	

	CWoWMainFrame();
	virtual ~CWoWMainFrame();	
	
	virtual void ScheduleShutdown();
	BOOL IsShutdownScheduled() const;

	virtual BOOL RegisterPauseKey();
	virtual BOOL UnregisterPauseKey();

	void SetTitleIcon(LPCTSTR lpszTitle, UINT nIconResID);
	CString GetTitle() const;
	HICON GetIcon() const;

	virtual void SetThread(CWoWThread* pThread, BOOL bAutoDestroy = FALSE);
	CWoWThread* GetThread();
	const CWoWThread* GetThread() const;

protected:

	DECLARE_DYNCREATE(CWoWMainFrame)
	// Generated message map functions
	//{{AFX_MSG(CWoWMainFrame)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	//}}AFX_MSG
	LRESULT OnHotKey(WPARAM wParam, LPARAM lParam);
	DECLARE_MESSAGE_MAP()

protected:	
	
	virtual void OnScheduleShutdown();
	virtual void OnUpdateScheduleShutdown(CCmdUI* pCmdUI);
	virtual void OnStart() {}
	virtual void OnStop() {}
	virtual BOOL PreStart() { return TRUE; }
	virtual BOOL PreStop() { return TRUE; }
	virtual void OnTick(DWORD dwTickCount) {}
	virtual void OnThreadMessage(WPARAM wParam, LPARAM lParam) {}	

private:	
	
	LRESULT _PreProcessThreadMsg(WPARAM wParam, LPARAM lParam);
	void _DestroyThread();

	HICON m_hIcon;
	CString m_sTitle;	
	CShutdown m_shutdown;
	CWoWThread* m_pThread;
	BOOL m_bDestroyThread;
};

#endif // __WOWMAINFRAME_H__