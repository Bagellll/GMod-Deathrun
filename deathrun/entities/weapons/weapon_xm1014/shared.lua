if ( CLIENT ) then

	SWEP.PrintName			= "XM1014"			
	SWEP.Author				= "Counter-Strike"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "k"
	
	killicon.AddFont( "weapon_xm1014", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
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

SWEP.Primary.Sound			= Sound( "Weapon_xm1014.Single" )
SWEP.Primary.Recoil			= 7
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.20
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Shotgun = true

SWEP.IronSightsPos = Vector( 5.14, -5, 2.14 )
SWEP.IronSightsAng = Vector(0, 0.8, 0)


/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	self:SetIronsights( false )
	
	// Already reloading
	if ( self:GetNWBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self:SetNWBool( "reloading", true )
		self:SetVar( "reloadtimer", CurTime() + 0.3 )
		self:SendWeaponAnim( ACT_VM_RELOAD )
		self:GetOwner():DoReloadEvent()
	end

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()


	if ( self:GetNWBool( "reloading", false ) ) then
	
		if ( self:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self:SetNWBool( "reloading", false )
				return
			end
			
			// Next cycle
			self:SetVar( "reloadtimer", CurTime() + 0.3 )
			self:SendWeaponAnim( ACT_VM_RELOAD )
			self:GetOwner():DoReloadEvent()
			
			// Add ammo
			self:GetOwner():RemoveAmmo( 1, self.Primary.Ammo, false )
			self:SetClip1(  self:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				self:GetOwner():DoReloadEvent()
			else
			
			end
			
		end
	
	end

end

