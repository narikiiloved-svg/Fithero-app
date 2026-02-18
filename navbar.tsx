'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from './auth-provider'
import { ThemeToggle } from './theme-toggle'
import { Dumbbell, LogOut, User, LayoutDashboard, Calendar, Settings } from 'lucide-react'
import { Button } from './ui/button'

export function Navbar() {
  const { user, signOut } = useAuth()
  const pathname = usePathname()

  const isActive = (path: string) => pathname === path

  if (!user) {
    return (
      <nav className="border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-50">
        <div className="container mx-auto px-4">
          <div className="flex h-16 items-center justify-between">
            <Link href="/" className="flex items-center space-x-2">
              <Dumbbell className="h-8 w-8 text-primary" />
              <span className="text-xl font-bold font-[family-name:var(--font-oswald)] tracking-wide">
                FITHERO
              </span>
            </Link>
            <div className="flex items-center space-x-4">
              <ThemeToggle />
              <Link href="/login">
                <Button variant="ghost">Iniciar Sesión</Button>
              </Link>
              <Link href="/register">
                <Button>Registrarse</Button>
              </Link>
            </div>
          </div>
        </div>
      </nav>
    )
  }

  return (
    <nav className="border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-50">
      <div className="container mx-auto px-4">
        <div className="flex h-16 items-center justify-between">
          <Link href="/" className="flex items-center space-x-2">
            <Dumbbell className="h-8 w-8 text-primary" />
            <span className="text-xl font-bold font-[family-name:var(--font-oswald)] tracking-wide">
              FITHERO
            </span>
          </Link>

          <div className="hidden md:flex items-center space-x-1">
            <Link href="/dashboard">
              <Button
                variant={isActive('/dashboard') ? 'default' : 'ghost'}
                size="sm"
                className="gap-2"
              >
                <LayoutDashboard className="h-4 w-4" />
                Dashboard
              </Button>
            </Link>
            <Link href="/plan">
              <Button
                variant={isActive('/plan') ? 'default' : 'ghost'}
                size="sm"
                className="gap-2"
              >
                <Calendar className="h-4 w-4" />
                Mi Plan
              </Button>
            </Link>
            <Link href="/profile">
              <Button
                variant={isActive('/profile') ? 'default' : 'ghost'}
                size="sm"
                className="gap-2"
              >
                <User className="h-4 w-4" />
                Perfil
              </Button>
            </Link>
          </div>

          <div className="flex items-center space-x-2">
            <ThemeToggle />
            <Button
              variant="ghost"
              size="icon"
              onClick={() => signOut()}
              title="Cerrar Sesión"
            >
              <LogOut className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
    </nav>
  )
}
