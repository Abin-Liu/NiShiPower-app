//////////////////////////////////////////////////////////////////////
// InputThread.h: interface for the CInputThread class.
//
// An abstract class for in-game hacking input-simulating thread.
//
// Abin (abinn32@yahoo.com)
// 02/12/2012
//////////////////////////////////////////////////////////////////////

#ifndef __INPUTTHREAD_H__
#define __INPUTTHREAD_H__

#include <windows.h>

#define INPUT_MOUSE_LEFT	0x01 // Left mouse button
#define INPUT_MOUSE_RIGHT	0x02 // Right mouse button
#define INPUT_MOUSE_MIDDLE	0x04 // Middle mouse button

class __declspec(dllexport) CInputThread
{

public:		

	// Derived classes should use new identifiers no smaller than MSG_APP + 1
	enum { MSG_NONE = 0, MSG_START, MSG_STOP, MSG_TICK, MSG_APP = 255 };

	CInputThread();
	virtual ~CInputThread();

	// Start & stop
	virtual BOOL Start(HWND hInputWnd); // Start a thread
	virtual BOOL Stop(DWORD dwTimeout = INFINITE); // Stop the running thread

	// Thread status
	BOOL IsRunning() const; // Is the thread is alive?
	BOOL IsStopping() const; // The thread being stopped? Application's ThreadProc function shall keep tracking this!	

	// Conditional sleep, only sleep when IsStopping() returns zero
	virtual void ConditionalSleep(DWORD dwMillseconds, DWORD dwMinimumMilliseconds = 100) const;
	virtual void SetMessageWnd(HWND hWnd, UINT nMsgID);
	virtual void PostMessage(UINT nType, LPARAM lParam = 0) const;	

	HWND GetInputWnd() const;
	BOOL IsValidInputWnd() const;
	BOOL IsInputWndForeground() const;
	BOOL ActivateInputWnd() const;
	BOOL CloseInputWnd() const;

	static BOOL PlayWaveSound(UINT nResourceID, HMODULE hModule, BOOL bAsync, BOOL bLoop = FALSE);
	static BOOL PlayWaveSound(LPCSTR lpszFilePath, BOOL bAsync, BOOL bLoop = FALSE);
	static void StopWaveSound();

	static void ReleaseAllKeys();
	static void RemoveKeyRedundancy(WORD wVKCode, WORD& wModifier);
	static void KeyDown(WORD wVKCode, WORD wModifier);
	static void KeyDown(DWORD dwKeys);
	static void KeyUp(WORD wVKCode, WORD wModifier);
	static void KeyUp(DWORD dwKeys);
	static void KeyStroke(WORD wVKCode, WORD wModifier);
	static void KeyStroke(DWORD dwKeys);
	void MouseMove(int x, int y) const; // Move cursor to a position against the client area of game window
	static void MouseDown(WORD wButtons);
	static void MouseUp(WORD wButtons);
	static void MouseClick(WORD wButtons);
	static void MouseDblClick(WORD wButtons);

protected:
	
	/////////////////////////////////////////////////////////////////////////////
	// The thread process function, must be overridden! This is actually the core
	// of any derived classes. A thread is meaningless without implementing this
	// method. 
	/////////////////////////////////////////////////////////////////////////////
	virtual DWORD ThreadProc() = 0;
	virtual void OnStart() {}
	virtual void OnStop() {}

private:

	static HANDLE _CreateThread(LPTHREAD_START_ROUTINE lpfn, CInputThread* pParam);
	static BOOL _StopThread(HANDLE& hThread, DWORD dwTimeout);	
	static DWORD WINAPI _ThreadProc(LPVOID pParam);
	static DWORD WINAPI _TickProc(LPVOID pParam);

	volatile BOOL m_bAbort; // Abort signal
	HWND m_hInputWnd;
	HANDLE m_hThread; // The thread handle
	HANDLE m_hTickThread;
	HWND m_hMsgWnd;
	UINT m_nMsgID;
};

#endif // __INPUTTHREAD_H__