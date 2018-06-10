// WoWMainFrame.cpp : implementation file
//

#include "stdafx.h"
#include "WoWMainFrame.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define WM_TRAYNOTIFY	(WM_APP + 1357)
#define WM_WOWTHREAD	(WM_APP + 1358)
#define TMR_MAIN		(0)

/////////////////////////////////////////////////////////////////////////////
// CWoWMainFrame

IMPLEMENT_DYNCREATE(CWoWMainFrame, CTrayFrameWnd)

CWoWMainFrame::CWoWMainFrame()
{
	m_pThread = NULL;
	m_bDestroyThread = FALSE;
	::memset(&m_shutdown, 0, sizeof(m_shutdown));
}

CWoWMainFrame::~CWoWMainFrame()
{
	_DestroyThread();
}

BEGIN_MESSAGE_MAP(CWoWMainFrame, CTrayFrameWnd)
	//{{AFX_MSG_MAP(CWoWMainFrame)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	//}}AFX_MSG_MAP
	ON_TRAY_MESSAGE(WM_TRAYNOTIFY)
	ON_MESSAGE(WM_HOTKEY, OnHotKey)
	ON_MESSAGE(WM_WOWTHREAD, _PreProcessThreadMsg)
END_MESSAGE_MAP()

void CWoWMainFrame::SetTitleIcon(LPCTSTR lpszTitle, UINT nIconResID)
{
	m_sTitle = lpszTitle;
	m_hIcon = AfxGetApp()->LoadIcon(nIconResID);
	m_shutdown.SetWndParent(NULL, m_hIcon, m_sTitle);
}

HICON CWoWMainFrame::GetIcon() const
{
	return m_hIcon;
}

CString CWoWMainFrame::GetTitle() const
{
	return m_sTitle;
}

/////////////////////////////////////////////////////////////////////////////
// CWoWMainFrame message handlers

int CWoWMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CTrayFrameWnd::OnCreate(lpCreateStruct) == -1)
		return -1;

	SetWindowText(m_sTitle);
	if (m_pThread)
	{
		m_pThread->SetMessageWnd(m_hWnd, WM_WOWTHREAD);
		if (!RegisterPauseKey())
			return -1;
	}
	
	// TODO: Add your specialized creation code here
	CreateTray(WM_TRAYNOTIFY, m_hIcon, m_sTitle, _T("点击这里进行设置"), m_sTitle, NIIF_INFO);
	return 0;
}

void CWoWMainFrame::OnDestroy() 
{
	if (m_pThread)
	{
		m_pThread->Stop();
		UnregisterPauseKey();
	}

	CTrayFrameWnd::OnDestroy();
}

LRESULT CWoWMainFrame::OnHotKey(WPARAM wParam, LPARAM lParam)
{
	if (wParam == 0 && m_pThread)
	{
		HWND hWnd = m_pThread->GetWoWWindow();
		if (::GetForegroundWindow() == hWnd)
		{
			if (m_pThread->IsRunning())
			{
				if (PreStop())
					m_pThread->Stop();
			}
			else
			{
				if (PreStart())
					m_pThread->Start();
			}
		}
		else
		{
			MessageBox("请先将魔兽世界窗口置于前台再按\"Pause\"键。");
		}
	}
	return 0;
}

void CWoWMainFrame::ScheduleShutdown()
{
	if (m_pThread)
		m_pThread->Stop();
	m_shutdown.Schedule();
}

BOOL CWoWMainFrame::IsShutdownScheduled() const
{
	return m_shutdown.IsEnabled();
}

LRESULT CWoWMainFrame::_PreProcessThreadMsg(WPARAM wParam, LPARAM lParam)
{
	switch (wParam)
	{
	case CWoWThread::MSG_START:
		if (m_shutdown.TimeReached())
			m_shutdown.Clear();

		OnStart();
		break;

	case CWoWThread::MSG_STOP:
		OnStop();
		break;

	case CWoWThread::MSG_TICK:		
		if (m_shutdown.TimeReached())
		{
			m_pThread->Stop();
			m_pThread->CloseInputWnd();

			if (m_shutdown.NeedPowerOff())
				m_shutdown.PowerOff();
		}
		else if (!m_pThread->IsInputWndForeground())
		{
			m_pThread->ActivateInputWnd();
		}

		OnTick(lParam);
		break;

	default:
		OnThreadMessage(wParam, lParam);
		break;
	}
	
	return 0;
}

BOOL CWoWMainFrame::RegisterPauseKey()
{
	while (!::RegisterHotKey(m_hWnd, 0, 0, VK_PAUSE))
	{
		if (MessageBox(_T("无法注册按键\"Pause\"，此按键可能已被其它程序注册，请关闭所有可能注册了这个按键的程序后重试。"), NULL, MB_ICONEXCLAMATION | MB_RETRYCANCEL) == IDCANCEL)
			return FALSE;
	}
	return TRUE;
}

BOOL CWoWMainFrame::UnregisterPauseKey()
{
	return ::UnregisterHotKey(m_hWnd, 0);
}

void CWoWMainFrame::OnScheduleShutdown()
{
	ScheduleShutdown();
}

void CWoWMainFrame::OnUpdateScheduleShutdown(CCmdUI* pCmdUI) 
{
	// TODO: Add your command update UI handler code here
	pCmdUI->SetCheck(IsShutdownScheduled());
}

void CWoWMainFrame::SetThread(CWoWThread *pThread, BOOL bAutoDestroy)
{
	_DestroyThread();

	if (pThread)
	{
		m_bDestroyThread = bAutoDestroy;
		m_pThread = pThread;
	}
}

void CWoWMainFrame::_DestroyThread()
{
	if (!m_pThread)
		return;

	m_pThread->Stop();
	
	if (m_bDestroyThread)
	{
		delete m_pThread;
		m_pThread = NULL;
	}
}

CWoWThread* CWoWMainFrame::GetThread()
{
	return m_pThread;
}

const CWoWThread* CWoWMainFrame::GetThread() const
{
	return m_pThread;
}
