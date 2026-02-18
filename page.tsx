'use client'

import Link from 'next/link'
import { Dumbbell, Zap, Target, Users, ArrowRight, Flame, Shield, TrendingUp } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useAuth } from '@/components/auth-provider'

export default function HomePage() {
  const { user } = useAuth()

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-br from-hero-dark via-hero-gray to-hero-dark py-20 lg:py-32">
        {/* Background Pattern */}
        <div className="absolute inset-0 opacity-10">
          <div className="absolute inset-0" style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%232563EB' fill-opacity='0.4'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
          }} />
        </div>

        <div className="container relative mx-auto px-4">
          <div className="flex flex-col lg:flex-row items-center gap-12">
            <div className="flex-1 text-center lg:text-left">
              <div className="inline-flex items-center gap-2 bg-primary/20 text-primary px-4 py-2 rounded-full text-sm font-medium mb-6">
                <Zap className="h-4 w-4" />
                Transforma tu cuerpo hoy
              </div>
              <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold font-[family-name:var(--font-oswald)] leading-tight mb-6">
                CONVIÉRTETE EN
                <span className="text-primary block">TU PROPIO HÉROE</span>
              </h1>
              <p className="text-lg text-muted-foreground mb-8 max-w-xl mx-auto lg:mx-0">
                Planes de entrenamiento y nutrición personalizados diseñados para vos.
                Sin importar tu nivel,我们会帮你达到最佳状态。
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                {user ? (
                  <Link href="/dashboard">
                    <Button size="lg" className="text-lg px-8 py-6 gap-2">
                      Ir al Dashboard
                      <ArrowRight className="h-5 w-5" />
                    </Button>
                  </Link>
                ) : (
                  <>
                    <Link href="/register">
                      <Button size="lg" className="text-lg px-8 py-6 gap-2">
                        Empezar Gratis
                        <ArrowRight className="h-5 w-5" />
                      </Button>
                    </Link>
                    <Link href="/login">
                      <Button size="lg" variant="outline" className="text-lg px-8 py-6">
                        Iniciar Sesión
                      </Button>
                    </Link>
                  </>
                )}
              </div>
            </div>
            <div className="flex-1 flex justify-center lg:justify-end">
              <div className="relative">
                <div className="w-72 h-72 md:w-96 md:h-96 bg-gradient-to-br from-primary to-primary/50 rounded-full blur-3xl opacity-30 animate-pulse" />
                <div className="relative bg-card/50 backdrop-blur-sm rounded-2xl p-8 border border-primary/20 glow-blue">
                  <Dumbbell className="w-32 h-32 md:w-48 md:h-48 text-primary mx-auto" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-card/30">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold font-[family-name:var(--font-oswald)] mb-4">
              ¿POR QUÉ FITHERO?
            </h2>
            <p className="text-muted-foreground max-w-2xl mx-auto">
              Nuestra metodología está probada por miles de usuarios que han alcanzado sus metas
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="bg-card/50 p-8 rounded-xl border border-border hover:border-primary/50 transition-all card-hover">
              <div className="w-14 h-14 bg-primary/20 rounded-lg flex items-center justify-center mb-6">
                <Target className="h-7 w-7 text-primary" />
              </div>
              <h3 className="text-xl font-bold font-[family-name:var(--font-oswald)] mb-3">
                Planes Personalizados
              </h3>
              <p className="text-muted-foreground">
                Cada plan se adapta a tu nivel, objetivos y preferencias. Ya sea en casa o en el gym.
              </p>
            </div>

            <div className="bg-card/50 p-8 rounded-xl border border-border hover:border-primary/50 transition-all card-hover">
              <div className="w-14 h-14 bg-accent/20 rounded-lg flex items-center justify-center mb-6">
                <Flame className="h-7 w-7 text-accent" />
              </div>
              <h3 className="text-xl font-bold font-[family-name:var(--font-oswald)] mb-3">
                Nutrición Ajustada
              </h3>
              <p className="text-muted-foreground">
                Calculamos tus macros y calorías diarias para optimizar tus resultados.
              </p>
            </div>

            <div className="bg-card/50 p-8 rounded-xl border border-border hover:border-primary/50 transition-all card-hover">
              <div className="w-14 h-14 bg-primary/20 rounded-lg flex items-center justify-center mb-6">
                <TrendingUp className="h-7 w-7 text-primary" />
              </div>
              <h3 className="text-xl font-bold font-[family-name:var(--font-oswald)] mb-3">
                Seguimiento de Progreso
              </h3>
              <p className="text-muted-foreground">
                Gráficos y métricas para que veamos tu evolución día a día.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section className="py-20">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold font-[family-name:var(--font-oswald)] mb-4">
              CÓMO FUNCIONA
            </h2>
            <p className="text-muted-foreground max-w-2xl mx-auto">
              En solo 3 pasos tendrás tu plan personalizado
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-6 text-2xl font-bold font-[family-name:var(--font-oswald)]">
                1
              </div>
              <h3 className="text-xl font-bold mb-3">Crea tu Perfil</h3>
              <p className="text-muted-foreground">
                Cuéntanos tu edad, peso, altura, nivel y objetivos
              </p>
            </div>

            <div className="text-center">
              <div className="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-6 text-2xl font-bold font-[family-name:var(--font-oswald)]">
                2
              </div>
              <h3 className="text-xl font-bold mb-3">Recibe tu Plan</h3>
              <p className="text-muted-foreground">
                Te generamos un plan de 7 días adaptado a vos
              </p>
            </div>

            <div className="text-center">
              <div className="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-6 text-2xl font-bold font-[family-name:var(--font-oswald)]">
                3
              </div>
              <h3 className="text-xl font-bold mb-3">Entrena y Evoluciona</h3>
              <p className="text-muted-foreground">
                Registra tu progreso y alcanza tus metas
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-to-r from-primary/20 to-accent/20">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold font-[family-name:var(--font-oswald)] mb-6">
            ¿LISTO PARA EMPEZAR?
          </h2>
          <p className="text-muted-foreground max-w-xl mx-auto mb-8">
            Únete a miles de personas que ya están transformando su vida con FitHero
          </p>
          {!user && (
            <Link href="/register">
              <Button size="lg" className="text-lg px-8 py-6 gap-2">
                Crear Cuenta Gratis
                <ArrowRight className="h-5 w-5" />
              </Button>
            </Link>
          )}
        </div>
      </section>

      {/* Footer */}
      <footer className="py-8 border-t border-border">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="flex items-center gap-2">
              <Dumbbell className="h-6 w-6 text-primary" />
              <span className="font-bold font-[family-name:var(--font-oswald)]">FITHERO</span>
            </div>
            <p className="text-muted-foreground text-sm">
              © 2024 FitHero. Todos los derechos reservados.
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}
