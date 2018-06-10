// WowDC.h: interface for the CWowDC class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_WOWDC_H__CB079451_5100_4072_85B6_518C9DCC4B00__INCLUDED_)
#define AFX_WOWDC_H__CB079451_5100_4072_85B6_518C9DCC4B00__INCLUDED_

#define WOWDC_INVALID_COLOR (-1)

class CWowDC  
{
public:	
	CWowDC();
	virtual ~CWowDC();
	
	RECT GetClientRect() const;
	BOOL IsValid() const;
	COLORREF GetPixel(int x, int y) const;
	COLORREF GetPixel(POINT pt, int xOffset = 0, int yOffset = 0) const;
	HWND GetHWnd() const;
	
	BOOL UpdateDC();
	void ReleaseDC();

private:
	HWND m_hWnd;
	HDC m_hDC;	
};

#endif // !defined(AFX_WOWDC_H__CB079451_5100_4072_85B6_518C9DCC4B00__INCLUDED_)
