// NiShiPowerThread.cpp: implementation of the CNiShiPowerThread class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "NiShiPower.h"
#include "NiShiPowerThread.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNiShiPowerThread::CNiShiPowerThread()
{
	::memset(&m_keys, 0, sizeof(NISHIKEYS));
	m_keys.dwMainKey = AfxGetApp()->GetProfileInt("", "Main Key", 0);
	m_keys.dwMoveKey = AfxGetApp()->GetProfileInt("", "Move Key", 0);
	m_keys.dwInteractKey = AfxGetApp()->GetProfileInt("", "Interact Key", 0);
}

CNiShiPowerThread::~CNiShiPowerThread()
{
	AfxGetApp()->WriteProfileInt("", "Main Key", m_keys.dwMainKey);
	AfxGetApp()->WriteProfileInt("", "Move Key", m_keys.dwMoveKey);
	AfxGetApp()->WriteProfileInt("", "Interact Key", m_keys.dwInteractKey);
	Stop();
}

LPNISHIKEYS CNiShiPowerThread::GetKeys()
{
	return &m_keys;
}

BOOL CNiShiPowerThread::AreKeysValid() const
{
	return m_keys.dwInteractKey && m_keys.dwMainKey && m_keys.dwMoveKey;
}

DWORD CNiShiPowerThread::ThreadProc()
{
	if (!m_dc.UpdateDC())
		return 1;
	
	const COLORREF BLUE = RGB(0, 0, 255);
	const COLORREF YELLOW = RGB(255, 255, 0);
	const COLORREF RED = RGB(255, 0, 0);
	const COLORREF PURPLE = RGB(255, 0, 255);
	//const COLORREF CYAN = RGB(0, 255, 255);
	
	CRect rect;
	COLORREF pixel;
	BYTE r, g, b;

	while (!IsStopping())
	{
		ReleaseAllKeys(); // Clean keyboard states	

		rect = m_dc.GetClientRect();
		if (rect.Width() < 10 || rect.Height() < 10)
			return 1;

		pixel = m_dc.GetPixel(rect.CenterPoint().x, 0);
		r = GetRValue(pixel);
		g = GetGValue(pixel);
		b = GetBValue(pixel);
		pixel = RGB(r, g, b);		

		switch(pixel)
		{
		case BLUE:
			KeyStroke(m_keys.dwMainKey);
			break;

		case YELLOW:
			KeyStroke(m_keys.dwInteractKey);
			break;

		case RED:
			KeyDown(m_keys.dwMoveKey);			
			ConditionalSleep(800);
			KeyUp(m_keys.dwMoveKey);
			ConditionalSleep(1000);
			break;

		case PURPLE:
			KeyDown(m_keys.dwMoveKey);
			ConditionalSleep(100);
			KeyUp(m_keys.dwMoveKey);
			ConditionalSleep(1000);
			break;

		//case CYAN:
		//	KeyStroke(m_keys.dwMainKey);
		//	return 0;
		//	break;

		default:
			break;
		}		

		ConditionalSleep(200);
	}

	return 0;
}