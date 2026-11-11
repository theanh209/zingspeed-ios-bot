// File: Mods.h
#ifndef Mods_h
#define Mods_h

struct Mods {
    // Tab Cơ Bản
    bool TeleportAuto = false;
    bool TeleportButton = false;
    bool MiniBoot = false;
    bool ThoatNhanh = false;
    bool VoHanNitro = false;
    bool NitroNhanh = false;
    bool ECU3Luot = false;
    bool TuDuaXe = false;
    bool GiaToc = false;
    
    // Tab Auto Đua
    int AutoDuaMode = 1; // 1: Theo đường hướng dẫn, 2: Tự ra giữa đường
    bool AutoDuaLapTrinh = false;
    
    // Tab Nhân Vật / Xe
    bool KySinh = false;
    bool FakeTen = false;
    bool ModSkin = false;
    bool UnlockXeSkin = false;
    bool ModChiSoXe = false;
};

extern Mods mods;

#endif
