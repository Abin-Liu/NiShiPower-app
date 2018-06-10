// WowDC.cpp: implementation of the CWowDC class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "WowDC.h"
#include "WoWThread.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CWowDC::CWowDC()
{
	m_hWnd = NULL;
	m_hDC = NULL;	
}

CWowDC::~CWowDC()
{
	ReleaseDC();
}

BOOL CWowDC::UpdateDC()
{
	ReleaseDC();
	m_hWnd = CWoWThread::GetWoWWindow();
	if (m_hWnd)
		m_hDC = ::GetDCEx(m_hWnd, NULL, 0);
	return IsValid();
}

void CWowDC::ReleaseDC()
{
	if (m_hDC)
	{
		::ReleaseDC(m_hWnd, m_hDC);
		m_hWnd = NULL;
		m_hDC = NULL;
	}
}

BOOL CWowDC::IsValid() const
{
	return m_hDC != NULL;
}

COLORREF CWowDC::GetPixel(POINT pt, int xOffset, int yOffset) const
{
	return GetPixel(pt.x + xOffset, pt.y + yOffset);
}

COLORREF CWowDC::GetPixel(int x, int y) const
{
	return IsValid() ? ::GetPixel(m_hDC, x, y) : WOWDC_INVALID_COLOR;
}

RECT CWowDC::GetClientRect() const
{
	RECT rect = { 0 };
	if (IsValid())
		::GetClientRect(m_hWnd, &rect);
	return rect;
}

HWND CWowDC::GetHWnd() const
{
	return m_hWnd;
}
