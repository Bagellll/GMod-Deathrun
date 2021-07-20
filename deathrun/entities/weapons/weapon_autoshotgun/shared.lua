if ( CLIENT ) then

	SWEP.PrintName			= "Auto Shotgun"			
	SWEP.Author				= "Counter-Strike Imported To Lua By Skydive."
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "k"
	
	killicon.AddFont( "weapon_autoshotgun", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end
SWEP.Slot				= 3

SWEP.HoldType			= "ar2"
SWEP.Base				= "weapon_cs_base"
SWEP.Category			= "Counter-Strike"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound 		    = Sound("Weapon_XM1014.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 7.5
SWEP.Primary.NumShots		= 12
SWEP.Primary.Cone 	    	= 0.045
SWEP.Primary.ClipSize 		= 6
SWEP.Primary.Delay 		    = 0.25
SWEP.Primary.DefaultClip 	= 6
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector (5.1536, -3.817, 2.1621)
SWEP.IronSightsAng 		= Vector (-0.1466, 0.7799, 0)
SWEP.ShellInterval = 0.65
SWEP.Shotgun = true
SWEP.NextReload = 0


function SWEP:Reload()
	
	--print( self.ReloadingShotgun )

	if (self:Clip1() == self.Primary.ClipSize) or self.ReloadingShotgun == true then return end
	if CurTime() < self.NextReload then return end

	--self:DefaultReload( ACT_VM_RELOAD );
	
	self:SetIronsights( false, true )

	self.ReloadingShotgun = true
	self.NextShell = CurTime() + 0.1
	self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )

	--print( self.ReloadingShotgun )
	--print( CurTime(), self.NextShell )
end

function SWEP:PrimaryAttack2()
	self.NextReload = CurTime() + 0.75
end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think2()

	if self.ReloadingShotgun then
		if self.NextShell < CurTime() then
			--self:SetNextPrimaryFire( self.NextShell )
			if (self:Clip1() < self.Primary.ClipSize) then
				
				self:SendWeaponAnim( ACT_VM_RELOAD )
				timer.Simple(self.ShellInterval*0.8, function()
					if IsValid(self) then
						if self.ReloadingShotgun then
							self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
						end
					end
				end)
				self:GetOwner():DoReloadEvent()
				self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
				self:SetClip1(  self:Clip1() + 1 )
				self.NextShell = CurTime() + self.ShellInterval

			elseif ( self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				self:GetOwner():DoReloadEvent()
				self.ReloadingShotgun = false
				timer.Simple(self.ShellInterval*0.8, function()
					if IsValid(self) then
						if not self.ReloadingShotgun then
							self:SendWeaponAnim( ACT_SHOTGUN_IDLE4 )
						end
					end
				end)
			end
		end
	end

	-- if ( self:GetNWBool( "reloading", false ) ) then
	
	-- 	if ( self:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
	-- 		-- Finsished reload -
	-- 		if ( self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
	-- 			self:SetNWBool( "reloading", false )
	-- 			return
	-- 		end
			
	-- 		-- Next cycle
	-- 		self:SetVar( "reloadtimer", CurTime() + 0.3 )
	-- 		self:SendWeaponAnim( ACT_VM_RELOAD )
	-- 		self:GetOwner():DoReloadEvent()
			
	-- 		-- Add ammo
	-- 		self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
	-- 		self:SetClip1(  self:Clip1() + 1 )
			
	-- 		-- Finish filling, final pump
	-- 		if ( self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
	-- 			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
	-- 			self:GetOwner():DoReloadEvent()
	-- 		else
			
	-- 		end
			
	-- 	end
	
	-- end

end
