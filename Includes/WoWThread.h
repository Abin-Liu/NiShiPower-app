// WoWThread.h: interface for the CWoWThread class.
//
//////////////////////////////////////////////////////////////////////

#ifndef __WOWTHREAD_H__
#define __WOWTHREAD_H__

#include "InputThread.h"

class __declspec(dllexport) CWoWThread : public CInputThread
{
public:

	CWoWThread();
	virtual ~CWoWThread();

	virtual BOOL Start(); // Start a thread

	static HWND GetWoWWindow();
	static int GetWoWPath(LPSTR lpszBuffer, int nMaxSize);
	static int GetAddOnsPath(LPSTR lpszBuffer, int nMaxSize);
};

#endif // __WOWTHREAD_H__
