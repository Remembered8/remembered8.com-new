import Link from 'next/link';
import type { Metadata } from 'next';

import { fetchMemorials } from '@/lib/api';

export const metadata: Metadata = {
  title: 'Remembered — Her insan hatırlanmayı hak eder',
  description:
    'Kuşaklar boyu süren, saygın ve kalıcı bir insan anısı arşivi. Sesleri, mektupları, görüntüleri ve düşünceleri korur.',
};

export const revalidate = 60;

export default async function Home() {
  const memorials = await fetchMemorials();

  return (
    <main className="mx-auto max-w-4xl px-4 py-10">
      <header className="border-b-2 border-[#111111] pb-6">
        <p className="font-mono text-[11px] uppercase tracking-widest text-[#777777]">
          Küresel insan mirası kütüğü
        </p>
        <h1 className="mt-2 font-serif text-4xl font-black tracking-tight text-[#111111]">
          Remembered
        </h1>
        <p className="mt-2 font-serif italic text-[#555555]">
          Her insan hatırlanmayı hak eder.
        </p>
      </header>

      {memorials.length === 0 ? (
        <p className="mt-8 border border-[#E5E5DF] bg-white p-4 font-serif text-[#444444]">
          Kütüğe şu an ulaşılamıyor.
        </p>
      ) : (
        <section className="mt-8">
          <h2 className="mb-4 font-mono text-[11px] uppercase tracking-wider text-[#777777]">
            Yaşayan miras dizini ({memorials.length})
          </h2>

          <ul className="divide-y divide-[#E5E5DF] border-y border-[#E5E5DF]">
            {memorials.map((memorial) => (
              <li key={memorial.id}>
                <Link
                  href={`/anma/${memorial.slug}`}
                  className="flex items-baseline justify-between gap-4 py-3 hover:bg-[#FAF8F5]"
                >
                  <span>
                    <span className="font-serif text-lg text-[#111111]">{memorial.fullName}</span>
                    {memorial.profession && (
                      <span className="ml-2 font-serif text-sm italic text-[#777777]">
                        {memorial.profession}
                      </span>
                    )}
                  </span>
                  <span className="shrink-0 font-mono text-[11px] text-[#8C5828]">
                    {memorial.candleCount.toLocaleString('tr-TR')} mum
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </section>
      )}
    </main>
  );
}
