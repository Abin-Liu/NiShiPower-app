// NiShiPowerThread.h: interface for the CNiShiPowerThread class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NISHIPOWERTHREAD_H__05149ECE_B0C8_4340_97B6_7B011F1FDD38__INCLUDED_)
#define AFX_NISHIPOWERTHREAD_H__05149ECE_B0C8_4340_97B6_7B011F1FDD38__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Includes\WoWThread.h"
#include "Includes\WowDC.h"

typedef struct _tagNiShiKeys
{
	DWORD dwMainKey;
	DWORD dwMoveKey;
	DWORD dwInteractKey;
} NISHIKEYS, *LPNISHIKEYS;

class CNiShiPowerThread : public CWoWThread  
{
public:
	BOOL AreKeysValid() const;

	LPNISHIKEYS GetKeys();
	CNiShiPowerThread();
	virtual ~CNiShiPowerThread();

protected:

	DWORD ThreadProc();
	CWowDC m_dc;
	NISHIKEYS m_keys;
};

#endif // !defined(AFX_NISHIPOWERTHREAD_H__05149ECE_B0C8_4340_97B6_7B011F1FDD38__INCLUDED_)
