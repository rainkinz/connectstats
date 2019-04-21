////////////////////////////////////////////////////////////////////////////////
// The following FIT Protocol software provided may be used with FIT protocol
// devices only and remains the copyrighted property of Garmin Canada Inc.
// The software is being provided on an "as-is" basis and as an accommodation,
// and therefore all warranties, representations, or guarantees of any kind
// (whether express, implied or statutory) including, without limitation,
// warranties of merchantability, non-infringement, or fitness for a particular
// purpose, are specifically disclaimed.
//
// Copyright 2018 Garmin Canada Inc.
////////////////////////////////////////////////////////////////////////////////
// ****WARNING****  This file is auto-generated!  Do NOT edit this file.
// Profile Version = 20.80Release
// Tag = production/akw/20.80.00-0-g64ad259
////////////////////////////////////////////////////////////////////////////////


#if !defined(FIT_PAD_MESG_HPP)
#define FIT_PAD_MESG_HPP

#include "fit_mesg.hpp"

namespace fit
{

class PadMesg : public Mesg
{
public:
    class FieldDefNum final
    {
    public:
       static const FIT_UINT8 Invalid = FIT_FIELD_NUM_INVALID;
    };

    PadMesg(void) : Mesg(Profile::MESG_PAD)
    {
    }

    PadMesg(const Mesg &mesg) : Mesg(mesg)
    {
    }

};

} // namespace fit

#endif // !defined(FIT_PAD_MESG_HPP)
